//
//  RemindersListItemView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI
import EventKit

fileprivate func createTestReminder() -> EKReminder {
    let eventStore = EKEventStore()
    let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
    
    newCalendar.title = "Test Calendar"
    
    #if os(macOS)
    newCalendar.color = NSColor.blue
    #else
    newCalendar.cgColor = UIColor.blue.cgColor
    #endif
    
    let newReminder = EKReminder(eventStore: eventStore)
    
    newReminder.calendar = newCalendar
    newReminder.title = "Test Event"
//    newReminder.startDate = Date()
    
    return newReminder
}

struct RemindersListItemView: View {
    let reminder: EKReminder
    
    init(reminder: EKReminder) {
        self.reminder = reminder
    }
    
    var body: some View {
        HStack(spacing: 10) {
            let circle = reminder.isCompleted ? "largecircle.fill.circle" : "circle"
            
            #if os(macOS)
            Image(systemName: circle)
                .font(.system(size: 20.0))
                .foregroundColor(Color(reminder.calendar.color!))
            #else
            Image(systemName: circle)
                .font(.system(size: 20.0))
                .foregroundColor(Color(UIColor(cgColor: reminder.calendar.cgColor!)))
            #endif
            
            VStack(alignment: .leading, spacing: 0) {
                Text(reminder.title)
                    .bold()
                
                HStack(alignment: .bottom) {
                    Text(reminder.calendar.title.trim())
                        .opacity(0.6)
                    
                    if reminder.notes != nil {
                        Text(reminder.notes!)
                            .opacity(0.6)
                            .font(.system(size: 11))
                    }
                }
            }
            
            if reminder.dueDateComponents?.hour != nil && reminder.dueDateComponents?.minute != nil {
                let date = (reminder.dueDateComponents?.date)!
                Spacer()
                
                Text(getLocalizedTime(date: date))
                    .opacity(0.8)
                    .if(date < Date()) { $0.foregroundColor(Color.red) }
            }
        }
        .padding(.vertical, 5)
        .if(reminder.isCompleted) { $0.opacity(0.4) }
        .frame(maxHeight: 50)
    }
}

struct RemindersListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersListItemView(reminder: createTestReminder())
    }
}


