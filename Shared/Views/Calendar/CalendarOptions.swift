//
//  CalendarOptions.swift
//  EinTag
//
//  Created by Alex Seifert on 21.12.20.
//

import SwiftUI
import EventKit

struct CalendarOptionsSheetView: View {
    @Binding var sheetView: CalendarRemindersSheetViewOptions?
    
    var body: some View {
        #if os(macOS)
        CalendarOptionsSheetViewContent(sheetView: $sheetView)
            .frame(maxWidth: .infinity, maxHeight: 500)
            .padding()
        #else
        NavigationView {
            CalendarOptionsSheetViewContent(sheetView: $sheetView)
                .navigationBarTitle(Text("Calendars"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.sheetView = nil
                }) {
                    Text("Done").bold()
                })
        }
        #endif
    }
}

fileprivate struct CalendarOptionsSheetViewContent: View {
    @EnvironmentObject var calendarData: CalendarData
    @Binding var sheetView: CalendarRemindersSheetViewOptions?
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(calendarData.sortedCalendarSources, id: \.self) { source in
                        let calendarsBySource = calendarData.calendarsBySource[source] ?? []
                        
                        #if os(macOS)
                        HeaderElement(text: source)
                
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(calendarsBySource, id: \.self) { calendar in
                                CalendarOptionView(calendar: calendar)
                            }
                        }
                        .padding(.bottom)
                        #else
                        HeaderElement(text: source)
                            .padding([.top, .horizontal])
                        
                        VStack(alignment: .leading) {
                            ForEach(calendarsBySource, id: \.self) { calendar in
                                CalendarOptionView(calendar: calendar)
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

fileprivate struct CalendarOptionView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @EnvironmentObject var calendarData: CalendarData
    private var calendar: EKCalendar
    
    init(calendar: EKCalendar) {
        self.calendar = calendar
    }
    
    var body: some View {
        let calendarActivated = calendarData.activatedCalendars.contains(calendar.calendarIdentifier)
        
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
                        calendarData.disableCalendar(calendarIdentifier: calendar.calendarIdentifier)
                    }
                    else {
                        calendarData.enableCalendar(calendarIdentifier: calendar.calendarIdentifier)
                    }
                }
        )
    }
}

struct CalendarOptionsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        CalendarOptionsSheetView(sheetView: .constant(.calendarOptions))
            .environmentObject(CalendarData(startDate: startDate, endDate: endDate))
    }
}
