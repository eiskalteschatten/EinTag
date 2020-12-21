//
//  Planner.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI
import EventKit

class PlannerData: ObservableObject {
    @Published var calendars: [EKCalendar] = []
    @Published var allEvents: [EKEvent] = []
    @Published var finishedLoading: Bool = false
    @Published var eventsDict: [Date: [EKEvent]] = [:]
    
    private var eventStore = EKEventStore()
    
    init() {
        eventStore.requestAccess(to: .event, completion:
            {(granted: Bool, error: Error?) -> Void in
                if granted {
                    DispatchQueue.main.async(execute: {
                        let today = Date()
                        let oneWeekFromToday = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: today)!
                        self.fetchEventsFromCalendar(withStart: today, end: oneWeekFromToday)
                        self.finishedLoading = true
                    })
                }
                else {
                    self.finishedLoading = true
                }
            })
    }
    
    func fetchEventsFromCalendar(withStart: Date, end: Date) {
        var allEvents: [EKEvent] = []
        
        self.calendars = self.eventStore.calendars(for: .event)
        
        for calendar in self.calendars {
            let predicate = self.eventStore.predicateForEvents(withStart: withStart.startOfDay, end: end.endOfDay, calendars: [calendar])
            let events = self.eventStore.events(matching: predicate)
            allEvents.append(contentsOf: events)
        }
        
        self.allEvents = allEvents
        self.transformData()
    }
    
    private func transformData() {
        for event in self.allEvents {
            if eventsDict[event.startDate.startOfDay] == nil {
                eventsDict[event.startDate.startOfDay] = []
            }
            
            eventsDict[event.startDate.startOfDay]?.append(event)
        }
    }
}
