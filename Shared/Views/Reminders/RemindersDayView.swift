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
    let date: Date
    let hideDate: Bool
    
    init(date: Date, hideDate: Bool = false) {
        self.date = date
        self.hideDate = hideDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !hideDate {
                Text(getLocalizedDate(date: date))
                    .font(.subheadline)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    .opacity(0.7)
                    .padding(.bottom, 15)
            }
            
            ForEach(remindersTestItems) { item in
                RemindersListItemView(listItem: item)
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
