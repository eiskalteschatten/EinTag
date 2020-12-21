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
    @EnvironmentObject var plannerData: PlannerData
    
    var eventStore = EKEventStore()
    let date: Date
    let hideDate: Bool
    
    init(date: Date, hideDate: Bool = false) {
        self.date = date
        self.hideDate = hideDate
    }
    
    var body: some View {
        let events = plannerData.eventsDict[date.startOfDay] ?? []
        
        VStack(alignment: .leading, spacing: 0) {
            if !hideDate {
                HeaderElement(text: getLocalizedDate(date: date))
            }
            
            if events.count > 0 {
                ForEach(events, id: \.self) { event in
                    PlannerListItemView(event: event)
                }
            }
            else {
                if !plannerData.finishedLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
                else {
                    Text("No events found.")
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

struct PlannerDayView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        PlannerDayView(date: Date())
            .environmentObject(PlannerData(startDate: startDate, endDate: endDate))
    }
}
