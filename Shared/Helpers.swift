//
//  Helpers.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import Foundation

func getLocalizedDate(date: Date = Date()) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale.autoupdatingCurrent
    return dateFormatter.string(from: date)
}

func getLocalizedDateWithFormat(date: Date = Date(), format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale.autoupdatingCurrent
    return dateFormatter.string(from: date)
}

func getLocalizedTime(date: Date = Date()) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    dateFormatter.locale = Locale.autoupdatingCurrent
    return dateFormatter.string(from: date)
}

func getLocalizedTemperature(temperatureInCelcius: Double) -> String {
    let temperature = Measurement(value: temperatureInCelcius, unit: UnitTemperature.celsius)
    let formatter = MeasurementFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    return formatter.string(from: temperature)
}

func getDatesForNextWeek() -> [Date] {
    let calendar = Calendar.current
    var date = calendar.startOfDay(for: Date())
    let endDate = calendar.date(byAdding: .weekOfYear, value: 1, to: date)!
    var dates: [Date] = []
    
    while date <= endDate {
        date = calendar.date(byAdding: .day, value: 1, to: date)!
        dates.append(date)
    }
    
    return dates
}
