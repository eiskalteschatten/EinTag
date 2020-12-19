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
    dateFormatter.locale = Locale.current
    return dateFormatter.string(from: date)
}

func getLocalizedTime(date: Date = Date()) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    dateFormatter.locale = Locale.current
    return dateFormatter.string(from: date)
}

func getLocalizedTemperature(temperatureInCelcius: Double) -> String {
    let temperature = Measurement(value: temperatureInCelcius, unit: UnitTemperature.celsius)
    let formatter = MeasurementFormatter()
    formatter.locale = Locale.current
    return formatter.string(from: temperature)
}
