//
//  Calendars.swift
//  EinTag
//
//  Created by Alex Seifert on 21.12.20.
//

import SwiftUI
import EventKit

struct CalendarsOptionsSheetView: View {
    @Binding var showingCalendarOptions: Bool
    
    var body: some View {
        #if os(macOS)
        CalendarsOptionsSheetViewContent(showingCalendarOptions: $showingCalendarOptions)
            .frame(maxWidth: .infinity, maxHeight: 500)
            .padding()
        #else
        NavigationView {
            CalendarsOptionsSheetViewContent(showingCalendarOptions: $showingCalendarOptions)
                .navigationBarTitle(Text("Calendars"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showingCalendarOptions = false
                }) {
                    Text("Done").bold()
                })
        }
        #endif
    }
}

fileprivate struct CalendarsOptionsSheetViewContent: View {
    @EnvironmentObject var plannerData: PlannerData
    @Binding var showingCalendarOptions: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(plannerData.sortedCalendarSources, id: \.self) { source in
                        let calendarsBySource = plannerData.calendarsBySource[source] ?? []
                        
                        #if os(macOS)
                        HeaderElement(text: source)
                
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(calendarsBySource, id: \.self) { calendar in
                                CalendarsOptionView(calendar: calendar)
                            }
                        }
                        .padding(.bottom)
                        #else
                        HeaderElement(text: source)
                            .padding([.top, .horizontal])
                        
                        VStack(alignment: .leading) {
                            ForEach(calendarsBySource, id: \.self) { calendar in
                                CalendarsOptionView(calendar: calendar)
                            }
                        }
                        .padding([.bottom, .horizontal])
                        #endif
                    }
                }
            }
            
            #if os(macOS)
            Button("OK") { self.showingCalendarOptions = false }
            #endif
        }
    }
}

fileprivate struct CalendarsOptionView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @EnvironmentObject var plannerData: PlannerData
    private var calendar: EKCalendar
    
    init(calendar: EKCalendar) {
        self.calendar = calendar
    }
    
    var body: some View {
        let calendarActivated = plannerData.activatedCalendars.contains(calendar.calendarIdentifier)
        
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
                        plannerData.disableCalendar(calendarIdentifier: calendar.calendarIdentifier)
                    }
                    else {
                        plannerData.enableCalendar(calendarIdentifier: calendar.calendarIdentifier)
                    }
                }
        )
    }
}

struct CalendarsOptionsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        CalendarsOptionsSheetView(showingCalendarOptions: .constant(true))
            .environmentObject(PlannerData(startDate: startDate, endDate: endDate))
    }
}
