//
//  RemindersDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI

struct RemindersDayView: View {
    @EnvironmentObject var reminderData: ReminderData
    
    private let date: Date
    private let hideDate: Bool
    
    init(date: Date, hideDate: Bool = false) {
        self.date = date
        self.hideDate = hideDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let reminders = reminderData.allReminders
                .filter { $0.dueDateComponents?.date?.startOfDay == date.startOfDay }
                .sorted { ($0.dueDateComponents?.date)! < ($1.dueDateComponents?.date)! }
            
            if !hideDate {
                HeaderElement(text: getLocalizedDate(date: date))
            }
            
            if reminders.count > 0 {
                ForEach(reminders, id: \.self.calendarItemIdentifier) { reminder in
                    RemindersListItemView(reminder: reminder)
                }
            }
            else {
                if !reminderData.finishedLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
                else {
                    Text("No reminders found.")
                        .opacity(0.3)
                }
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct RemindersDayView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersDayView(date: Date())
    }
}
