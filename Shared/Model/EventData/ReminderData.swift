//
//  ReminderData.swift
//  EinTag
//
//  Created by Alex Seifert on 12/22/20.
//

import SwiftUI
import EventKit

class ReminderData: AbstractEventData {
    @Published var allReminders: [EKReminder] = []
    @Published var activeReminders: [EKReminder] = []
    
    init(startDate: Date, endDate: Date) {
        super.init(startDate: startDate, endDate: endDate, entityType: EKEntityType.reminder, userDefaultsKey: USER_DEFAULT_ACTIVATED_REMINDERS_KEY)
    }
    
    override func fetchData() {
        self.calendars = self.eventStore.calendars(for: self.entityType)
        
        if (self.activatedCalendars.count == 0) {
            self.activatedCalendars = self.calendars.map { $0.calendarIdentifier }
            self.updateActivatedCalendars()
        }
        
        let predicate = self.eventStore.predicateForReminders(in: nil)
        self.eventStore.fetchReminders(matching: predicate, completion: { reminders in
            self.allReminders = reminders ?? []
            self.transformData()
        })
    }
    
    override func transformEvents() {
        self.activeReminders = self.allReminders.filter { self.activatedCalendars.contains($0.calendar.calendarIdentifier) }
    }
    
    func updateReminder(updatedReminder: EKReminder) {
        if let index = self.allReminders.firstIndex(where: { $0.calendarItemIdentifier == updatedReminder.calendarItemIdentifier }) {
            self.allReminders[index] = updatedReminder
            self.transformEvents()
            self.objectWillChange.send()
        }
        
        DispatchQueue.main.async(execute: {
            do {
                try self.eventStore.save(updatedReminder, commit: true)
            }
            catch {
                print("Could not update the reminder!")
            }
        })
    }
    
    func deleteReminder(reminderToDelete: EKReminder) {
        if let index = self.allReminders.firstIndex(where: { $0.calendarItemIdentifier == reminderToDelete.calendarItemIdentifier }) {
            self.allReminders.remove(at: index)
            self.transformEvents()
            self.objectWillChange.send()
        }
        
        DispatchQueue.main.async(execute: {
            do {
                try self.eventStore.remove(reminderToDelete, commit: true)
                self.fetchData()
            }
            catch {
                print("Could not delete the reminder!")
            }
        })
    }
}
