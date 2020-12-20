//
//  PlannerView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct PlannerView: View {
    @ObservedObject var plannerData = PlannerData()
    
    var body: some View {
        ScrollView {
            VStack {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let dayOfWeek = calendar.component(.weekday, from: today)
                let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
                let days = (weekdays.lowerBound ..< weekdays.upperBound)
                    .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
                
                ForEach(days, id: \.self) { days in
                    PlannerDayView(date: days, plannerData: plannerData)
                        .padding(.horizontal)
                }
            }
        }
        .toolbar {
            #if os(macOS)
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            #endif
        }
        
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
    
