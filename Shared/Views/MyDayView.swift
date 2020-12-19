//
//  MyDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

enum TemperatureUnit: Hashable {
   case celcius, fahrenheit
}

struct MyDayView: View {
    #if !os(macOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif
    
    @State private var temperatureUnit: TemperatureUnit = .celcius
    
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
                
                MyDayWeatherView(temperatureUnit: temperatureUnit)
            }
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
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: {}) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    Picker(selection: $temperatureUnit, label: Text("Temparture Unit")) {
                        Text("Celcius").tag(TemperatureUnit.celcius)
                        Text("Fahrenheit").tag(TemperatureUnit.fahrenheit)
                    }
                }
                label: {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
}

struct MyDayView_Previews: PreviewProvider {
    static var previews: some View {
        MyDayView()
    }
}

struct MyDayWeatherView: View {
    var temperatureUnit: TemperatureUnit?
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            Image(systemName: "cloud.sun.bolt.fill")
                .font(.system(size: 60.0))
            
            let temperatureText = temperatureUnit == .celcius ? "5°C" : "5°F";
            
            Text(temperatureText)
                .font(.title)
                .padding()
        }
    }
}
