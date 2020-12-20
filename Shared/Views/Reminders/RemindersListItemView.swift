//
//  RemindersListItemView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI

let remindersTestItem = RemindersListItem(
                            id: 0,
                            list: "Home",
                            listColor: Color.blue,
                            done: true,
                            title: "Test Reminder",
                            note: "A note of some sort goes here",
                            date: Date()
                        )

struct RemindersListItemView: View {
    let listItem: RemindersListItem
    
    init(listItem: RemindersListItem) {
        self.listItem = listItem
    }
    
    var body: some View {
        HStack(spacing: 10) {
            let circle = listItem.done ? "largecircle.fill.circle" : "circle"
            
            Image(systemName: circle)
                .font(.system(size: 20.0))
                .foregroundColor(listItem.listColor)
            
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

struct RemindersListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersListItemView(listItem: remindersTestItem)
    }
}


