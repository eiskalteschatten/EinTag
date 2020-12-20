//
//  WeatherDay.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import Foundation
import SwiftUI

struct WeatherDay: Hashable, Identifiable {
    var id: Int
    var temperatureInCelcius: Double
    var highTemperature: Double
    var lowTemperature: Double
    var date: Date
}
