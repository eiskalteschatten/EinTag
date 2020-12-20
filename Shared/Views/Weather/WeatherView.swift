//
//  WeatherView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI

private let testWeatherDays = [
    WeatherDay(
        id: 0,
        temperatureInCelcius: -2.0,
        highTemperature: 12.0,
        lowTemperature: -10.0,
        date: Date()
    ),
    WeatherDay(
        id: 1,
        temperatureInCelcius: 22.0,
        highTemperature: 25.0,
        lowTemperature: 18.0,
        date: Date()
    )
]

struct WeatherView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("München")
                    .font(.title)
                    .padding()
                
                WeatherIconView()
                    .padding(.bottom, 20)
            }
            
            VStack(alignment: .leading) {
                Text("Daily")
                    .font(.title)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 50) {
                        ForEach(testWeatherDays) { day in
                            WeatherDayView(weatherDay: day)
                        }
                    }
                }
            }
            .padding()
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
        .background(Color.blue)
    }
}

struct WeatherDayView: View {
    let weatherDay: WeatherDay
    
    init(weatherDay: WeatherDay) {
        self.weatherDay = weatherDay
    }
    
    var body: some View {
        let highTemperature = getLocalizedTemperature(temperatureInCelcius: weatherDay.highTemperature)
        let lowTemperature = getLocalizedTemperature(temperatureInCelcius: weatherDay.lowTemperature)
        
        let date = getLocalizedDateWithFormat(date: weatherDay.date, format: "EE, dd")
        
        VStack(alignment: .leading, spacing: 10) {
            Text(date)
                .font(.title2)
            
            Image(systemName: "cloud.rain.fill")
                .renderingMode(.original)
                .font(.system(size: 25.0))
            
            HStack {
                Text(highTemperature)
                    .bold()
                    .font(.title2)
                
                Text(lowTemperature)
                    .font(.title3)
            }
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

