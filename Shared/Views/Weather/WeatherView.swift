//
//  WeatherView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("München")
                    .font(.title)
                    .padding()
                
                WeatherIconView()
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

struct WeatherIconView: View {
    let temperatureFontSize: CGFloat
    
    init(temperatureFontSize: CGFloat = 70.0) {
        self.temperatureFontSize = temperatureFontSize
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "cloud.sun.bolt.fill")
                    .renderingMode(.original)
                    .font(.system(size: 50.0))
            }
            
            let temperature = getLocalizedTemperature(temperatureInCelcius: 25.0)
            
            Text(temperature)
                .font(.system(size: temperatureFontSize))
                .padding()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

