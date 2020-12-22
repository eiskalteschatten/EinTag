//
//  Reminders.swift
//  EinTag
//
//  Created by Alex Seifert on 12/22/20.
//

import SwiftUI
import EventKit

class ReminderData: ObservableObject {
    @Published var calendars: [EKCalendar] = []
    @Published var allEvents: [EKEvent] = []
    @Published var finishedLoading: Bool = false
    @Published var eventsDict: [Date: [EKEvent]] = [:]
    @Published var calendarsBySource: [String: [EKCalendar]] = [:]
    @Published var sortedCalendarSources: [String] = []
    @Published var activatedCalendars: [String] = UserDefaults.standard.stringArray(forKey: USER_DEFAULT_ACTIVATED_CALENDARS_KEY) ?? []
    
    private var eventStore = EKEventStore()
    private var startDate: Date
    private var endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        
        eventStore.requestAccess(to: .reminder, completion:
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
        
        self.calendars = self.eventStore.calendars(for: .reminder)
        
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
    
    func disableCalendar(calendarIdentifier: String) {
        if let index = self.activatedCalendars.firstIndex(of: calendarIdentifier) {
            self.activatedCalendars.remove(at: index)
        }
        
        self.updateActivatedCalendars()
    }
    
    func enableCalendar(calendarIdentifier: String) {
        self.activatedCalendars.append(calendarIdentifier)
        self.updateActivatedCalendars()
    }
    
    private func updateActivatedCalendars() {
        UserDefaults.standard.set(self.activatedCalendars, forKey: USER_DEFAULT_ACTIVATED_CALENDARS_KEY)
        self.transformEvents()
    }
    
    private func transformData() {
        self.transformCalendars()
        self.transformEvents()
    }
    
    private func transformCalendars() {
        var _calendarsBySource: [String: [EKCalendar]] = [:]
        
        self.sortedCalendarSources = Array(Set(self.calendars.map { $0.source.title })).sorted { $0.lowercased() < $1.lowercased() }
        
        for source in self.sortedCalendarSources {
            if _calendarsBySource[source] == nil {
                _calendarsBySource[source] = []
            }
            
            _calendarsBySource[source] = self.calendars.filter { $0.source.title == source }.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }

        self.calendarsBySource = _calendarsBySource
    }
    
    private func transformEvents() {
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

