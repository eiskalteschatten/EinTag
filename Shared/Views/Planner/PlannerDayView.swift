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
    @ObservedObject var plannerData = PlannerData()
    @State var finishedLoading: Bool = false
    
    var eventStore = EKEventStore()
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
            
            
            if plannerData.events.count > 0 {
                ForEach(plannerData.events, id: \.self) { event in
                    PlannerListItemView(event: event)
                }
            }
            else {
                if !finishedLoading {
                    HStack {
                        Spacer()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        Spacer()
                    }
                }
                else {
                    Text("No events could be found in your planner for this day.")
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
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
        .onAppear{
            eventStore.requestAccess(to: .event, completion:
                {(granted: Bool, error: Error?) -> Void in
                    if granted {
                        DispatchQueue.main.async(execute: {
                            var allEvents: [EKEvent] = []
                            
                            plannerData.calendars = eventStore.calendars(for: .event)
                            
                            for calendar in plannerData.calendars {
                                let predicate = eventStore.predicateForEvents(withStart: date.startOfDay, end: date.endOfDay, calendars: [calendar])
                                let events = eventStore.events(matching: predicate)
                                allEvents.append(contentsOf: events)
                            }
                            
                            plannerData.events = allEvents
                            finishedLoading = true
                        })
                    }
                    else {
                        finishedLoading = true
                    }
            })
        }
    }
}

struct PlannerDayView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerDayView(date: Date())
    }
}
