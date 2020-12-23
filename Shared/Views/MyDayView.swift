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
    
    @State private var sheetView: CalendarRemindersSheetViewOptions?
    
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
                    MyDayCalendarView()
                    MyDayRemindersView()
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
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 22.0))
                }
            }
            #endif
            ToolbarItem() {
                Menu {
                    Button(action: { sheetView = .calendarOptions }) {
                        Label("Manage Calendars", systemImage: "calendar.circle")
                    }
                    Button(action: { sheetView = .remindersOptions }) {
                        Label("Manage Reminder Lists", systemImage: "checkmark.circle")
                    }
                }
                label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 22.0))
                }
            }
        }
        .sheet(item: $sheetView) { item in
            switch item {
            case .calendarOptions:
                CalendarOptionsSheetView(sheetView: $sheetView)
            case .remindersOptions:
                RemindersOptionsSheetView(sheetView: $sheetView)
            }
        }
    }
}

fileprivate struct MyDayCalendarView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Calendar")
                .font(.title)

            CalendarDayView(date: Date(), hideDate: true)
                .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

fileprivate struct MyDayRemindersView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Reminders")
                .font(.title)

            RemindersDayView(date: Date(), hideDate: true)
                .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

struct MyDayView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        MyDayView()
            .environmentObject(CalendarData(startDate: startDate, endDate: endDate))
            .environmentObject(ReminderData(startDate: startDate, endDate: endDate))
    }
}
