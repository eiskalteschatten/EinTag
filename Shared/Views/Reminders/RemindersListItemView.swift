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
    
    return newReminder
}

struct RemindersListItemView: View {
    @EnvironmentObject var reminderData: ReminderData
    @State var showDeleteConfirmation = false
    let reminder: EKReminder
    
    init(reminder: EKReminder) {
        self.reminder = reminder
    }
    
    var body: some View {
        #if os(macOS)
        let titleSize = CGFloat(14)
        let titlePadding = CGFloat(0)
        let calendarTitleSize = CGFloat(12)
        let maxHeight = CGFloat(50)
        let verticalPadding = CGFloat(6)
        #else
        let titleSize = CGFloat(16)
        let titlePadding = CGFloat(4)
        let calendarTitleSize = CGFloat(14)
        let maxHeight = CGFloat(55)
        let verticalPadding = CGFloat(20)
        #endif
        
        HStack(spacing: 10) {
            let circle = self.reminder.isCompleted ? "largecircle.fill.circle" : "circle"
            
            #if os(macOS)
            Image(systemName: circle)
                .font(.system(size: 20.0))
                .foregroundColor(Color(reminder.calendar.color!))
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            self.toggleReminderIsCompleted()
                        }
                )
            #else
            Image(systemName: circle)
                .font(.system(size: 25.0))
                .foregroundColor(Color(UIColor(cgColor: reminder.calendar.cgColor!)))
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            self.toggleReminderIsCompleted()
                        }
                )
            #endif
            
            VStack(alignment: .leading, spacing: 0) {
                Text(reminder.title)
                    .font(.system(size: titleSize))
                    .padding(.bottom, titlePadding)
                
                HStack(alignment: .bottom) {
                    Text(reminder.calendar.title.trim())
                        .font(.system(size: calendarTitleSize))
                        .opacity(0.6)
                    
                    if reminder.notes != nil {
                        Text(reminder.notes!)
                            .opacity(0.6)
                            .font(.system(size: 11))
                    }
                }
            }
            
            #if os(macOS)
            if reminder.dueDateComponents?.hour != nil && reminder.dueDateComponents?.minute != nil {
                let date = (reminder.dueDateComponents?.date)!
                Spacer()
                
                Text(getLocalizedTime(date: date))
                    .opacity(0.8)
                    .if(date < Date()) { $0.foregroundColor(Color.red) }
            }
            #else
            Spacer()
            
            if reminder.dueDateComponents?.hour != nil && reminder.dueDateComponents?.minute != nil {
                let date = (reminder.dueDateComponents?.date)!
                
                Text(getLocalizedTime(date: date))
                    .opacity(0.8)
                    .font(.system(size: 13.0))
                    .if(date < Date()) { $0.foregroundColor(Color.red) }
            }
            
            Image(systemName: "ellipsis.circle")
                .font(.system(size: 22.0))
                .foregroundColor(Color.blue)
            #endif
        }
        .padding(.vertical, verticalPadding)
        .if(self.reminder.isCompleted) { $0.opacity(0.4) }
        .frame(maxHeight: maxHeight)
        .contextMenu {
            let isCompletedToggleText = self.reminder.isCompleted ? "Mark as Incomplete" : "Mark as Completed"
            
            Button(isCompletedToggleText) {
                self.toggleReminderIsCompleted()
            }
            
            Button("Delete Reminder") {
                self.showDeleteConfirmation.toggle()
            }
        }
        .alert(isPresented: self.$showDeleteConfirmation) {
            Alert(
                title: Text("Delete reminder?"),
                message: Text("Are you sure you want to delete this reminder?"),
                primaryButton: .default(Text("No")),
                secondaryButton: .default(Text("Yes"), action: {
                    self.reminderData.deleteReminder(reminderToDelete: self.reminder)
                })
            )
        }
    }
    
    private func toggleReminderIsCompleted() {
        self.reminder.isCompleted = !self.reminder.isCompleted
        reminderData.updateReminder(updatedReminder: self.reminder)
    }
}

struct RemindersListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersListItemView(reminder: createTestReminder())
    }
}


