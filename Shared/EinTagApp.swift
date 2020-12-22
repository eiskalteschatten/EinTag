//
//  EinTagApp.swift
//  Shared
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

@main
struct EinTagApp: App {
    #if os(macOS)
    let foregroundNotification = NSApplication.willBecomeActiveNotification
    #else
    let foregroundNotification = UIApplication.willEnterForegroundNotification
    #endif
    
    private var calendarData: CalendarData
    private var reminderData: ReminderData
    
    init() {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startDate)!
        self.calendarData = CalendarData(startDate: startDate, endDate: endDate)
        self.reminderData = ReminderData(startDate: startDate, endDate: endDate)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(calendarData)
                .environmentObject(reminderData)
                .onReceive(NotificationCenter.default.publisher(for: foregroundNotification)) { _ in
                    self.calendarData.fetchData()
                    self.reminderData.fetchData()
                }
        }
        .commands {
            SidebarCommands()
        }
    }
}
