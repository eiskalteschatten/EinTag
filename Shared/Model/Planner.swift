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
    private var startDate: Date
    private var endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        
        eventStore.requestAccess(to: .event, completion:
            {(granted: Bool, error: Error?) -> Void in
                if granted {
                    DispatchQueue.main.async(execute: {
                        self.fetchEventsFromCalendar()
                        self.finishedLoading = true
                    })
                }
                else {
                    self.finishedLoading = true
                }
            })
    }
    
    func fetchEventsFromCalendar() {
        var allEvents: [EKEvent] = []
        
        self.calendars = self.eventStore.calendars(for: .event)
        
        for calendar in self.calendars {
            let predicate = self.eventStore.predicateForEvents(withStart: self.startDate.startOfDay, end: self.endDate.endOfDay, calendars: [calendar])
            let events = self.eventStore.events(matching: predicate)
            allEvents.append(contentsOf: events)
        }
        
        self.allEvents = allEvents
        self.transformData()
    }
    
    private func transformData() {
        var _eventsDict: [Date: [EKEvent]] = [:]
        
        for event in self.allEvents {
            if _eventsDict[event.startDate.startOfDay] == nil {
                _eventsDict[event.startDate.startOfDay] = []
            }
            
            _eventsDict[event.startDate.startOfDay]?.append(event)
        }
        
        for (key, value) in _eventsDict {
            _eventsDict[key] = value.sorted {
                if $0.isAllDay && !$1.isAllDay {
                    return $0.title < $1.title
                }
                
                return $0.startDate < $1.startDate
            }
        }
        
        self.eventsDict = _eventsDict
    }
}
