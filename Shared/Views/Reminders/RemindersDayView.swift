//
//  RemindersDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI

let remindersTestItems = [
    RemindersListItem(
        id: 0,
        list: "Band",
        listColor: Color.green,
        done: true,
        title: "Test Reminder",
        note: "A note of some sort goes here",
        date: Date()
    ),
    RemindersListItem(
        id: 1,
        list: "Home",
        listColor: Color.blue,
        done: false,
        title: "Some other reminder",
        note: "More notes!",
        date: Date().addingTimeInterval(5 * 60)
    )
]

struct RemindersDayView: View {
    @EnvironmentObject var reminderData: ReminderData
    
    let date: Date
    let hideDate: Bool
    
    init(date: Date, hideDate: Bool = false) {
        self.date = date
        self.hideDate = hideDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let reminders = reminderData.allReminders.filter { $0.dueDateComponents?.date?.startOfDay == date.startOfDay }
            
            if !hideDate {
                HeaderElement(text: getLocalizedDate(date: date))
            }
            
            if reminders.count > 0 {
                ForEach(reminders, id: \.self) { reminder in
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
        .padding(.vertical)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}

struct RemindersDayView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersDayView(date: Date())
    }
}
