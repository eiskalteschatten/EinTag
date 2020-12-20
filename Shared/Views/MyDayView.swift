//
//  MyDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct MyDayView: View {
    #if os(macOS)
    let minWidth: CGFloat = 500
    #else
    @Environment(\.horizontalSizeClass) var sizeClass
    let minWidth: CGFloat = 300
    #endif
    
    var body: some View {
        VStack(alignment: .leading) {
            AdaptiveStack(verticalAlignment: .top) {
                Text(getLocalizedDate())
                    .font(.system(size: 35.0))
                
                #if os(macOS)
                Spacer()
                #else
                if sizeClass != .compact {
                    Spacer()
                }
                #endif
                
                WeatherIconView(temperatureFontSize: 40.0)
            }
            .padding()
            
            AdaptiveStack {
                MyDayPlannerView()
                    .padding(.leading)
                
                MyDayRemindersView()
                    .padding(.horizontal)
            }
                
            Spacer()
        }
        .frame(
            minWidth: minWidth,
            maxWidth: .infinity,
            minHeight: 200,
            maxHeight: .infinity,
            alignment: .topLeading
        )
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

struct MyDayPlannerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Planner")
                .font(.title)

            ScrollView {
                PlannerDayView(date: Date(), hideDate: true)
            }
        }
    }
}

struct MyDayRemindersView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Reminders")
                .font(.title)

            ScrollView {
                RemindersDayView(date: Date(), hideDate: true)
            }
        }
    }
}

struct MyDayView_Previews: PreviewProvider {
    static var previews: some View {
        MyDayView()
            
    }
}
