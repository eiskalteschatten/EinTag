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
            ToolbarItem() {
                Menu {
                    Button(action: { sheetView = .calendarOptions }) {
                        Label("Calendars", systemImage: "calendar.circle")
                    }
                    Button(action: { sheetView = .remindersOptions }) {
                        Label("Reminders", systemImage: "checkmark.circle")
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

struct MyWeekView_Previews: PreviewProvider {
    static var previews: some View {
        MyWeekView()
    }
}
    
