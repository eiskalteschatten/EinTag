//
//  PlannerListItemView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

let plannerTestItem = PlannerListItem(
                id: 0,
                calendar: "Home",
                calendarColor: Color.blue,
                title: "Test Event",
                note: "A note of some sort goes here",
                date: Date()
            )

struct PlannerListItemView: View {
    let listItem: PlannerListItem
    
    init(listItem: PlannerListItem) {
        self.listItem = listItem
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(listItem.calendarColor)
                .frame(width: 6)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(listItem.title)
                    .bold()
                
                HStack(alignment: .bottom) {
                    Text(getLocalizedTime(date: listItem.date))
                        .padding(.trailing, 3)
                    
                    Text(listItem.note)
                        .opacity(0.6)
                        .font(.system(size: 11))
                }
            }
        }
        .padding(.vertical, 5)
        .frame(
            maxHeight: 50
        )
    }
}

struct PlannerListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerListItemView(listItem: plannerTestItem)
    }
}
