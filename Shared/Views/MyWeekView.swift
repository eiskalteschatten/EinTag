//
//  MyWeekView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

fileprivate enum SheetViewOptions {
    case calendarOptions, remindersOptions
}

struct MyWeekView: View {
    @State private var showSheet = false
    @State private var sheetView: SheetViewOptions = .calendarOptions
    
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

struct MyWeekView_Previews: PreviewProvider {
    static var previews: some View {
        MyWeekView()
    }
}
    
