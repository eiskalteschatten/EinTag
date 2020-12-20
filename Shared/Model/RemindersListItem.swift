//
//  RemindersListItem.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import Foundation
import SwiftUI

struct RemindersListItem: Hashable, Identifiable {
    var id: Int
    var calendar: String
    var calendarColor: Color
    var title: String
    var note: String
    var date: Date
}

