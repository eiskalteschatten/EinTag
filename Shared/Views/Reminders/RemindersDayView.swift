//
//  RemindersDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI

let remindersTestItems = [
    PlannerListItem(
        id: 0,
        calendar: "Work",
        calendarColor: Color.red,
        title: "Test Event",
        note: "A note of some sort goes here",
        date: Date()
    ),
    PlannerListItem(
        id: 1,
        calendar: "Home",
        calendarColor: Color.blue,
        title: "Some other event",
        note: "More notes!",
        date: Date().addingTimeInterval(5 * 60)
    )
]

struct RemindersDayView: View {
    let date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(getLocalizedDate(date: date))
                .font(.subheadline)
                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                .opacity(0.7)
                .padding(.bottom, 15)
            
            ForEach(plannerTestItems) { item in
                PlannerListItemView(listItem: item)
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
