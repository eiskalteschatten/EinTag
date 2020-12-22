//
//  PlannerView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct PlannerView: View {
    @State var showingCalendarOptions = false
    
    var body: some View {
        ScrollView {
            VStack {
                let dates = getDatesForNextWeek()
                
                ForEach(dates, id: \.self) { date in
                    PlannerDayView(date: date)
                        .padding(.horizontal)
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

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
    
