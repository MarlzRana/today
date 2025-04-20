//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Marlin Ranasinghe on 20/04/2025.
//

import EventKit
import Foundation

extension Reminder {
    init(with ekReminder: EKReminder) throws {
        // You must specify a "date and time" in the date (i.e it cannot be relative" for this guard to be satisfied
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else { throw TodayError.reminderHasNoDueDate }
        
        self.id = ekReminder.calendarItemIdentifier
        self.title = ekReminder.title
        self.dueDate = dueDate
        self.notes = ekReminder.notes
        self.isComplete = ekReminder.isCompleted
    }
}
