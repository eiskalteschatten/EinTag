//
//  Planner.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI
import EventKit

class PlannerData: AbstractEventData {
    @Published var allEvents: [EKEvent] = []
    @Published var eventsDict: [Date: [EKEvent]] = [:]
    
    init(startDate: Date, endDate: Date) {
        super.init(startDate: startDate, endDate: endDate, entityType: EKEntityType.event, userDefaultsKey: USER_DEFAULT_ACTIVATED_CALENDARS_KEY)
    }
    
    override func fetchEventsFromCalendar() {
        var allEvents: [EKEvent] = []
        
        self.calendars = self.eventStore.calendars(for: self.entityType)
        
        if (self.activatedCalendars.count == 0) {
            self.activatedCalendars = self.calendars.map { $0.calendarIdentifier }
            self.updateActivatedCalendars()
        }
        
        for calendar in self.calendars {
            let predicate = self.eventStore.predicateForEvents(withStart: self.startDate.startOfDay, end: self.endDate.endOfDay, calendars: [calendar])
            let events = self.eventStore.events(matching: predicate)
            allEvents.append(contentsOf: events)
        }
        
        self.allEvents = allEvents
        self.transformData()
    }
    
    override func transformEvents() {
        var _eventsDict: [Date: [EKEvent]] = [:]
        
        for event in self.allEvents {
            if _eventsDict[event.startDate.startOfDay] == nil {
                _eventsDict[event.startDate.startOfDay] = []
            }
            
            if self.activatedCalendars.contains(event.calendar.calendarIdentifier) {
                _eventsDict[event.startDate.startOfDay]?.append(event)
            }
        }
        
        for (key, value) in _eventsDict {
            _eventsDict[key] = value.sorted {
                if $0.isAllDay && !$1.isAllDay {
                    return $0.title.lowercased() < $1.title.lowercased()
                }
                
                return $0.startDate < $1.startDate
            }
        }
        
        self.eventsDict = _eventsDict
    }
}
