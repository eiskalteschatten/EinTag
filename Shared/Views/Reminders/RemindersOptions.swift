//
//  RemindersOptions.swift
//  EinTag
//
//  Created by Alex Seifert on 12/22/20.
//

import SwiftUI
import EventKit

struct RemindersOptionsSheetView: View {
    @Binding var sheetView: CalendarRemindersSheetViewOptions?
    
    var body: some View {
        #if os(macOS)
        RemindersOptionsSheetViewContent(sheetView: $sheetView)
            .frame(maxWidth: .infinity, maxHeight: 500)
            .padding()
        #else
        NavigationView {
            RemindersOptionsSheetViewContent(sheetView: $sheetView)
                .navigationBarTitle(Text("Reminder Lists"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.sheetView = nil
                }) {
                    Text("Done").bold()
                })
        }
        #endif
    }
}

fileprivate struct RemindersOptionsSheetViewContent: View {
    @EnvironmentObject var reminderData: ReminderData
    @Binding var sheetView: CalendarRemindersSheetViewOptions?
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(reminderData.sortedCalendarSources, id: \.self) { source in
                        let calendarsBySource = reminderData.calendarsBySource[source] ?? []
                        
                        #if os(macOS)
                        HeaderElement(text: source)
                
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(calendarsBySource, id: \.self) { calendar in
                                RemindersOptionView(calendar: calendar)
                            }
                        }
                        .padding(.bottom)
                        #else
                        HeaderElement(text: source)
                            .padding([.top, .horizontal])
                        
                        VStack(alignment: .leading) {
                            ForEach(calendarsBySource, id: \.self) { calendar in
                                RemindersOptionView(calendar: calendar)
                            }
                        }
                        .padding([.bottom, .horizontal])
                        #endif
                    }
                }
            }
            
            #if os(macOS)
            Button("OK") { self.sheetView = nil }
            #endif
        }
    }
}

fileprivate struct RemindersOptionView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @EnvironmentObject var reminderData: ReminderData
    private var calendar: EKCalendar
    
    init(calendar: EKCalendar) {
        self.calendar = calendar
    }
    
    var body: some View {
        let calendarActivated = reminderData.activatedCalendars.contains(calendar.calendarIdentifier)
        
        HStack {
            let circle = calendarActivated ? "checkmark.circle.fill" : "circle"
            
            #if os(macOS)
            Image(systemName: circle)
                .font(.system(size: 20.0))
                .foregroundColor(Color(calendar.color))
            #else
            Image(systemName: circle)
                .font(.system(size: 20.0))
                .foregroundColor(Color(UIColor(cgColor: calendar.cgColor!)))
            #endif
            
            Text(self.calendar.title)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 40,
            maxHeight: .infinity,
            alignment: .leading
        )
        .gesture(
            TapGesture()
                .onEnded { _ in
                    if calendarActivated {
                        reminderData.disableCalendar(calendarIdentifier: calendar.calendarIdentifier)
                    }
                    else {
                        reminderData.enableCalendar(calendarIdentifier: calendar.calendarIdentifier)
                    }
                }
        )
    }
}

struct RemindersOptionsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        RemindersOptionsSheetView(sheetView: .constant(.remindersOptions))
            .environmentObject(CalendarData(startDate: startDate, endDate: endDate))
    }
}

