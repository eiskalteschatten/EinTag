//
//  PlannerDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI
import EventKit

let plannerTestItems = [
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

struct PlannerDayView: View {
    let date: Date
    let calendarData: CalendarData
    let hideDate: Bool
    
    init(date: Date, calendarData: CalendarData, hideDate: Bool = false) {
        self.date = date
        self.calendarData = calendarData
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
            
            ForEach(calendarData.events, id: \.self) { event in
                PlannerListItemView(event: event)
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

struct PlannerDayView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerDayView(date: Date(), calendarData: CalendarData())
    }
}

