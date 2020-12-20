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
    var list: String
    var listColor: Color
    var done: Bool
    var title: String
    var note: String
    var date: Date
}

