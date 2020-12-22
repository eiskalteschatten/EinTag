//
//  PlannerDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI
import EventKit

struct PlannerDayView: View {
    @EnvironmentObject var plannerData: PlannerData
    
    private let date: Date
    private let hideDate: Bool
    
    init(date: Date, hideDate: Bool = false) {
        self.date = date
        self.hideDate = hideDate
    }
    
    var body: some View {
        let events = plannerData.eventsDict[date.startOfDay] ?? []
        
        VStack(alignment: .leading, spacing: 0) {
            if !hideDate {
                HeaderElement(text: getLocalizedDate(date: date))
            }
            
            if events.count > 0 {
                ForEach(events, id: \.self.calendarItemIdentifier) { event in
                    PlannerListItemView(event: event)
                }
            }
            else {
                if !plannerData.finishedLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
                else {
                    Text("No events found.")
                        .opacity(0.3)
                }
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct PlannerDayView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        PlannerDayView(date: Date())
            .environmentObject(PlannerData(startDate: startDate, endDate: endDate))
    }
}
