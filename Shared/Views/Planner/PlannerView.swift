//
//  PlannerView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI
import EventKit

struct PlannerView: View {
    var body: some View {
        ScrollView {
            VStack {
//                PlannerDayView(date: Date())
//                PlannerDayView(date: Date())
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

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
