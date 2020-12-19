//
//  MyDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct MyDayView: View {
    #if !os(macOS)
    @Environment(\.horizontalSizeClass) var sizeClass
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
                
                MyDayWeatherView()
            }
            .padding()
            
            MyDayPlannerView()
                .padding()
            
            Spacer()
        }
        .frame(
            minWidth: 400,
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

struct MyDayWeatherView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            Image(systemName: "cloud.sun.bolt.fill")
                .font(.system(size: 60.0))
            
            let temperature = getLocalizedTemperature(temperatureInCelcius: 25.0)
            
            Text(temperature)
                .font(.title)
                .padding()
        }
    }
}

struct MyDayPlannerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Planner")
                .font(.title)
            
            PlannerDayView(date: Date())
        }
    }
}

struct MyDayView_Previews: PreviewProvider {
    static var previews: some View {
        MyDayView()
    }
}
