//
//  Reminders.swift
//  EinTag
//
//  Created by Alex Seifert on 12/22/20.
//

import SwiftUI
import EventKit

class ReminderData: AbstractEventData {
    init(startDate: Date, endDate: Date) {
        super.init(startDate: startDate, endDate: endDate, entityType: EKEntityType.reminder)
        self.activatedCalendars = UserDefaults.standard.stringArray(forKey: USER_DEFAULT_ACTIVATED_REMINDERS_KEY) ?? []
    }
}

