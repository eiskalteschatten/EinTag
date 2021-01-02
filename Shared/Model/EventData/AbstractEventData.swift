//
//  AbstractEventData.swift
//  EinTag
//
//  Created by Alex Seifert on 12/22/20.
//

import SwiftUI
import EventKit

class AbstractEventData: ObservableObject {
    @Published var calendars: [EKCalendar] = []
    @Published var finishedLoading: Bool = false
    @Published var calendarsBySource: [String: [EKCalendar]] = [:]
    @Published var sortedCalendarSources: [String] = []
    @Published var activatedCalendars: [String] = []
    
    internal var eventStore = EKEventStore()
    internal var startDate: Date
    internal var endDate: Date
    internal var entityType: EKEntityType
    internal var userDefaultsKey: String
    
    init(startDate: Date, endDate: Date, entityType: EKEntityType, userDefaultsKey: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.entityType = entityType
        self.userDefaultsKey = userDefaultsKey
        self.activatedCalendars = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        
        eventStore.requestAccess(to: self.entityType, completion:
            {(granted: Bool, error: Error?) -> Void in
                if granted {
                    DispatchQueue.main.async(execute: {
                        self.fetchData()
                        self.finishedLoading = true
                    })
                }
                else {
                    self.finishedLoading = true
                }
            })
    }
    
    func fetchData() {
        fatalError("Must override this function")
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
    
    internal func updateActivatedCalendars() {
        UserDefaults.standard.set(self.activatedCalendars, forKey: userDefaultsKey)
        self.transformEvents()
    }
    
    internal func transformData() {
        self.transformCalendars()
        self.transformEvents()
    }
    
    private func transformCalendars() {
        DispatchQueue.main.async(execute: {
            var _calendarsBySource: [String: [EKCalendar]] = [:]
            
            self.sortedCalendarSources = Array(Set(self.calendars.map { $0.source.title })).sorted { $0.lowercased() < $1.lowercased() }
            
            for source in self.sortedCalendarSources {
                if _calendarsBySource[source] == nil {
                    _calendarsBySource[source] = []
                }
                
                _calendarsBySource[source] = self.calendars.filter { $0.source.title == source }.sorted { $0.title.lowercased() < $1.title.lowercased() }
            }

            self.calendarsBySource = _calendarsBySource
        })
    }
    
    internal func transformEvents() {
        fatalError("Must override this function")
    }
}

