//
//  CalendarListItemView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI
import EventKit

fileprivate func createTestEvent() -> EKEvent {
    let eventStore = EKEventStore()
    let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
    
    newCalendar.title = "Test Calendar"
    
    #if os(macOS)
    newCalendar.color = NSColor.blue
    #else
    newCalendar.cgColor = UIColor.blue.cgColor
    #endif
    
    let newEvent = EKEvent(eventStore: eventStore)
    
    newEvent.calendar = newCalendar
    newEvent.title = "Test Event"
    newEvent.startDate = Date()
    newEvent.endDate = Date().addingTimeInterval(5 * 60)
    
    return newEvent
}

struct CalendarListItemView: View {
    let event: EKEvent
    
    init(event: EKEvent) {
        self.event = event
    }
    
    var body: some View {
        #if os(macOS)
        let titleSize = CGFloat(14)
        let titlePadding = CGFloat(0)
        let calendarTitleSize = CGFloat(12)
        let calendarColorHeight = CGFloat(35)
        let calendarColor = Color(event.calendar.color!)
        let maxHeight = CGFloat(50)
        let verticalPadding = CGFloat(6)
        #else
        let titleSize = CGFloat(16)
        let titlePadding = CGFloat(4)
        let calendarTitleSize = CGFloat(14)
        let calendarColor = Color(UIColor(cgColor: event.calendar.cgColor!))
        let calendarColorHeight = CGFloat(40)
        let maxHeight = CGFloat(55)
        let verticalPadding = CGFloat(20)
        #endif
        
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .fill(calendarColor)
                .frame(width: 6, height: calendarColorHeight)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(event.title)
                        .font(.system(size: titleSize))
                        .padding(.bottom, titlePadding)
                    
                    Spacer()
                    
                    if !event.isAllDay {
                        Text(getLocalizedTime(date: event.startDate))
                    }
                }
                
                HStack(alignment: .bottom) {
                    Text(event.calendar.title.trim())
                        .font(.system(size: calendarTitleSize))
                        .opacity(0.6)
                    
                    Spacer()
                    
                    if !event.isAllDay {
                        Text(getLocalizedTime(date: event.endDate))
                            .opacity(0.5)
                    }
                }
            }
            
            if event.isAllDay {
                Spacer()
                
                Text("All-day")
                    .opacity(0.8)
            }
        }
        .padding(.vertical, verticalPadding)
        .if(event.endDate.isInThePast) { $0.opacity(0.4) }
        .frame(maxHeight: maxHeight)
    }
}

struct CalendarListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarListItemView(event: createTestEvent())
    }
}

