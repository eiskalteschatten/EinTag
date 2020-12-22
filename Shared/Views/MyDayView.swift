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
    
    @State var showingCalendarOptions = false
    
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
                        .padding(.horizontal)
                    
                    MyDayRemindersView()
                        .padding(.horizontal)
                }
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
            ToolbarItem {
                Button(action: {}) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            #endif
            ToolbarItem() {
                Menu {
                    Button(action: { self.showingCalendarOptions.toggle() }) {
                        Label("Manage Calendars", systemImage: "calendar.circle")
                    }
                }
                label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingCalendarOptions) {
            CalendarsOptionsSheetView(showingCalendarOptions: $showingCalendarOptions)
        }
    }
}

fileprivate struct MyDayPlannerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Events")
                .font(.title)

            PlannerDayView(date: Date(), hideDate: true)
        }
    }
}

fileprivate struct MyDayRemindersView: View {
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
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        MyDayView()
            .environmentObject(PlannerData(startDate: startDate, endDate: endDate))
            .environmentObject(ReminderData(startDate: startDate, endDate: endDate))
    }
}
