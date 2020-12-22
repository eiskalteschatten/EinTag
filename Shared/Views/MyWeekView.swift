//
//  MyWeekView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct MyWeekView: View {
    @State private var sheetView: CalendarRemindersSheetViewOptions?
    
    var body: some View {
        ScrollView {
            VStack {
                let dates = getDatesForNextWeek()
                
                ForEach(dates, id: \.self) { date in
                    VStack {
                        CalendarDayView(date: date)
                            .padding([.horizontal, .top])
                        
                        RemindersDayView(date: date, hideDate: true)
                            .padding()
                    }
                }
            }
        }
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
                    Button(action: { sheetView = .calendarOptions }) {
                        Label("Manage Calendars", systemImage: "calendar.circle")
                    }
                    Button(action: { sheetView = .remindersOptions }) {
                        Label("Manage Reminder Lists", systemImage: "checkmark.circle")
                    }
                }
                label: {
                    Label("Menu", systemImage: "ellipsis.circle")
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

struct MyWeekView_Previews: PreviewProvider {
    static var previews: some View {
        MyWeekView()
    }
}
    
