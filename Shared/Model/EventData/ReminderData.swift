//
//  Reminders.swift
//  EinTag
//
//  Created by Alex Seifert on 12/22/20.
//

import SwiftUI
import EventKit

class ReminderData: AbstractEventData {
    @Published var allReminders: [EKReminder] = []
    
    init(startDate: Date, endDate: Date) {
        super.init(startDate: startDate, endDate: endDate, entityType: EKEntityType.reminder, userDefaultsKey: USER_DEFAULT_ACTIVATED_REMINDERS_KEY)
    }
    
    override func fetchEventsFromCalendar() {
        self.calendars = super.eventStore.calendars(for: super.entityType)
        
        if (self.activatedCalendars.count == 0) {
            self.activatedCalendars = self.calendars.map { $0.calendarIdentifier }
            super.updateActivatedCalendars()
        }
        
        let predicate = super.eventStore.predicateForReminders(in: nil)
        super.eventStore.fetchReminders(matching: predicate, completion: { reminders in
            self.allReminders = reminders ?? []
        })
        
        super.transformData()
    }
    
    override func transformEvents() {}
}

