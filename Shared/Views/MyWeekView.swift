//
//  MyWeekView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct MyWeekView: View {
    @State var showingCalendarOptions = false
    
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

struct MyWeekView_Previews: PreviewProvider {
    static var previews: some View {
        MyWeekView()
    }
}
    
