//
//  GlobalVariables.swift
//  EinTag
//
//  Created by Alex Seifert on 12/22/20.
//

import SwiftUI

enum CalendarRemindersSheetViewOptions: Identifiable {
    case calendarOptions, remindersOptions
    var id: Int { hashValue }
}
