//
//  PlannerListItemView.swift
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
    newCalendar.color = NSColor(Color.blue)
    
    let newEvent = EKEvent(eventStore: eventStore)
    
    newEvent.calendar = newCalendar
    newEvent.title = "Test Event"
    newEvent.startDate = Date()
    newEvent.endDate = Date().addingTimeInterval(5 * 60)
    
    return newEvent
}

struct PlannerListItemView: View {
    let event: EKEvent
    
    init(event: EKEvent) {
        self.event = event
    }
    
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .fill(Color(event.calendar.color))
                .frame(width: 6)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(event.title)
                        .bold()
                    
                    Spacer()
                    
                    if !event.isAllDay {
                        Text(getLocalizedTime(date: event.startDate))
                    }
                }
                
                HStack(alignment: .bottom) {
                    Text(event.calendar.title.trim())
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
        .padding(.vertical, 5)
        .if(event.endDate.isInThePast) { $0.opacity(0.4) }
        .frame(
            maxHeight: 50
        )
    }
}

struct PlannerListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerListItemView(event: createTestEvent())
    }
}

