//
//  MyDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI
import EventKit

struct MyDayView: View {
    #if os(macOS)
    let minWidth: CGFloat = 500
    #else
    @Environment(\.horizontalSizeClass) var sizeClass
    let minWidth: CGFloat = 300
    #endif
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                AdaptiveStack(verticalAlignment: .top) {
                    Text(getLocalizedDate())
                        .font(.system(size: 35.0))
                    
                    #if os(macOS)
                    Spacer()
                    #else
                    if sizeClass != .compact {
                        Spacer()
                    }
                    #endif
                    
                    WeatherIconView(temperatureFontSize: 40.0)
                }
                .padding()
            
                AdaptiveStack(verticalAlignment: .top) {
                    MyDayPlannerView()
                        .padding()
                    
                    MyDayRemindersView()
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .frame(
            minWidth: minWidth,
            maxWidth: .infinity,
            minHeight: 200,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .toolbar {
            #if os(macOS)
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            #endif
        }
    }
}

struct MyDayPlannerView: View {
    @ObservedObject var plannerData = PlannerData()
    var eventStore = EKEventStore()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Planner")
                .font(.title)

            PlannerDayView(date: Date(), plannerData: plannerData, hideDate: true)
        }
        .onAppear{
            eventStore.requestAccess(to: .event, completion:
                {(granted: Bool, error: Error?) -> Void in
                    if granted {
                        DispatchQueue.main.async(execute: {
                            let today = Date()
                            var allEvents: [EKEvent] = []
                            
                            plannerData.calendars = eventStore.calendars(for: .event)
                            
                            for calendar in plannerData.calendars {
                                let predicate = eventStore.predicateForEvents(withStart: today.startOfDay, end: today.endOfDay, calendars: [calendar])
                                let events = eventStore.events(matching: predicate)
                                allEvents.append(contentsOf: events)
                            }
                            
                            plannerData.events = allEvents
                            plannerData.finishedLoading = true
                        })
                    }
                    else {
                        print("Access to calendars denied")
                        plannerData.finishedLoading = true
                    }
                })
        }
    }
}

struct MyDayRemindersView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Reminders")
                .font(.title)

            RemindersDayView(date: Date(), hideDate: true)
        }
    }
}

struct MyDayView_Previews: PreviewProvider {
    static var previews: some View {
        MyDayView()
    }
}
