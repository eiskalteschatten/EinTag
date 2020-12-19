//
//  PlannerDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct PlannerDayView: View {
    let date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text(getLocalizedDate(date: date))
                .font(.subheadline)
                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                .opacity(0.7)
        }
        .padding(.vertical)
    }
}

struct PlannerDayView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerDayView(date: Date())
    }
}

