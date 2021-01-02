//
//  UserDefaultsEnv.swift
//  EinTag
//
//  Created by Alex Seifert on 27/12/2020.
//

import SwiftUI
import EventKit

class UserDefaultsEnv: ObservableObject {
    @Published var hideCompletedReminders: Bool = UserDefaults.standard.bool(forKey: USER_DEFAULT_HIDE_COMPLETED_REMINDERS_KEY) {
        didSet {
            UserDefaults.standard.set(hideCompletedReminders, forKey: USER_DEFAULT_HIDE_COMPLETED_REMINDERS_KEY)
        }
    }
}
