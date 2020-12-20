//
//  Calendar.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI
import EventKit

class CalendarData: ObservableObject {
    @Published var calendars: [EKCalendar] = []
    @Published var events: [EKEvent] = []
}
