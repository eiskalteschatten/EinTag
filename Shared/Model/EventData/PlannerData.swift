//
//  Planner.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI
import EventKit

class PlannerData: AbstractEventData {
    init(startDate: Date, endDate: Date) {
        super.init(startDate: startDate, endDate: endDate, entityType: EKEntityType.event)
        self.activatedCalendars = UserDefaults.standard.stringArray(forKey: USER_DEFAULT_ACTIVATED_CALENDARS_KEY) ?? []
    }
}
