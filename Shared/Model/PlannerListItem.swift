//
//  PlannerListItem.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import Foundation
import SwiftUI

struct PlannerListItem: Hashable, Identifiable {
    var id: Int
    var calendar: String
    var calendarColor: Color
    var title: String
    var note: String
    var date: Date
}

