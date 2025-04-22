//
//  ReminderStore.swift
//  Today
//
//  Created by Marlin Ranasinghe on 20/04/2025.
//

import EventKit
import Foundation

// The methods in a final class cannot be overriden
// The compiler will also throw a warning if you try to inherit a final class
final class ReminderStore {
    static let shared = ReminderStore()
    
    private let ekStore = EKEventStore()
    
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .fullAccess
    }
    
    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        
        switch status {
        case .fullAccess:
            return
        case .restricted, .writeOnly:
            throw TodayError.accessRestricted
        case .notDetermined:
            let accessGranted = try await ekStore.requestFullAccessToReminders()
            guard accessGranted else { throw TodayError.accessDenied }
        case .denied:
            throw TodayError.accessDenied
        // The @unknown annotation will warn you in case new enumerations are added to EKAuthorizationStatus
        // that you don't have a specific case statement for
        @unknown default:
            throw TodayError.unknown
        }
    }
    
    func readAll() async throws -> [Reminder] {
        guard isAvailable else { throw TodayError.accessDenied }
        
        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.reminders(matching: predicate)
        
        // compactMap works like a regular map but will also filter out nil values
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {
                return nil
            }
        }
        
        return reminders
    }
    
    @discardableResult // allows you to ignore the return value (with no warning)
    func save(_ reminder: Reminder) throws -> Reminder.ID {
        guard isAvailable else { throw TodayError.accessDenied }
        
        let ekReminder: EKReminder
        do {
            ekReminder = try read(with: reminder.id)
        } catch {
            ekReminder = EKReminder(eventStore: ekStore)
        }
        
        ekReminder.update(using: reminder, in: ekStore)
        try ekStore.save(ekReminder, commit: true)
        return ekReminder.calendarItemIdentifier
    }
    
    func delete(with id: Reminder.ID) throws {
        guard isAvailable else { throw TodayError.accessDenied }
        
        let ekReminder = try read(with: id)
        try ekStore.remove(ekReminder, commit: true)
    }
    
    private func read(with id: Reminder.ID) throws -> EKReminder{
        guard let ekReminder = ekStore.calendarItem(withIdentifier: id) as? EKReminder else { throw TodayError.failedReadingCalendarItem }
        
        return ekReminder
    }
}
