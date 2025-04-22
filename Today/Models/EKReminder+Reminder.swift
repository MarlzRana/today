//
//  EKReminder+Reminder.swift
//  Today
//
//  Created by Marlin Ranasinghe on 22/04/2025.
//

import EventKit
import Foundation

extension EKReminder {
    func update(using reminder: Reminder, in store: EKEventStore) {
        self.title = reminder.title
        self.notes = reminder.notes
        self.isCompleted = reminder.isComplete
        self.calendar = store.defaultCalendarForNewReminders()
        
        alarms?.forEach { alarm in
            guard let absoluteDate = alarm.absoluteDate else { return }
            let comparison = Locale.current.calendar.compare(reminder.dueDate, to: absoluteDate, toGranularity: .minute)
            
            if comparison != .orderedSame {
                removeAlarm(alarm)
            }
        }
        
        if !self.hasAlarms {
            self.addAlarm(EKAlarm(absoluteDate: reminder.dueDate))
        }
    }
}
