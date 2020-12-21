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
            .frame(minWidth: 200, minHeight: 200)
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
        Text("options")
        
        #if os(macOS)
        HStack {
            Spacer()
            Button("OK") { self.showingCalendarOptions = false }
        }
            .padding()
        #endif
    }
}
