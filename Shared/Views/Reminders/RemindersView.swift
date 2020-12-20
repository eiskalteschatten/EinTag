//
//  RemindersView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct RemindersView: View {
    var body: some View {
        ScrollView {
            VStack {
                RemindersDayView(date: Date())
                RemindersDayView(date: Date())
            }
            .padding(.leading)
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
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
