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
    @Published var events: [EKEvent] = []
    @Published var finishedLoading: Bool = false
    
    private var eventStore = EKEventStore()
    
    init() {
        eventStore.requestAccess(to: .event, completion:
            {(granted: Bool, error: Error?) -> Void in
                if granted {
                    DispatchQueue.main.async(execute: {
                        var allEvents: [EKEvent] = []
                        let today = Date()
                        let oneWeekFromToday = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: today)!
                        
                        self.calendars = self.eventStore.calendars(for: .event)
                        
                        for calendar in self.calendars {
                            let predicate = self.eventStore.predicateForEvents(withStart: today.startOfDay, end: oneWeekFromToday.endOfDay, calendars: [calendar])
                            let events = self.eventStore.events(matching: predicate)
                            allEvents.append(contentsOf: events)
                        }
                        
                        self.events = allEvents
                        self.finishedLoading = true
                    })
                }
                else {
                    self.finishedLoading = true
                }
            })
    }
}

    
