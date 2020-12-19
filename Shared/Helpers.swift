//
//  Helpers.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import Foundation

func getLocalizedDate() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale.current
    return dateFormatter.string(from: date)
}
