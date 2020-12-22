//
//  MyDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI
import EventKit

fileprivate enum SheetViewOptions {
    case calendarOptions, remindersOptions
}

struct MyDayView: View {
    #if os(macOS)
    let minWidth: CGFloat = 500
    #else
    @Environment(\.horizontalSizeClass) var sizeClass
    let minWidth: CGFloat = 300
    #endif
    
    @State private var showSheet = false
    @State private var sheetView: SheetViewOptions = .calendarOptions
    
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
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            #endif
            ToolbarItem() {
                Menu {
                    Button(action: {
                        self.sheetView = .calendarOptions
                        self.showSheet.toggle()
                    }) {
                        Label("Manage Calendars", systemImage: "calendar.circle")
                    }
                    Button(action: {
                        self.sheetView = .remindersOptions
                        self.showSheet.toggle()
                    }) {
                        Label("Manage Reminder Lists", systemImage: "checkmark.circle")
                    }
                }
                label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            if self.sheetView == .calendarOptions {
                CalendarOptionsSheetView(showSheet: $showSheet)
            }
            else if self.sheetView == .remindersOptions {
                RemindersOptionsSheetView(showSheet: $showSheet)
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
