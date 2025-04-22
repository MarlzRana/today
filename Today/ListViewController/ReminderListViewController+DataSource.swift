//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Marlin Ranasinghe on 16/03/2025.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    private var reminderStore: ReminderStore { ReminderStore.shared }
    
    var completedReminderValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var notCompletedReminderValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        // Let's make sure we don't reload reminders that no longer visible in the filtered view
        let ids = idsThatChanged.filter { id in filteredReminders.contains(where: {$0.id == id}) }
        
        // Create some new state
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(self.filteredReminders.map {$0.id})
        
        // If we have modified some reminders (but their ids have stayed constant), let's explicitly ask UIKit to reload them
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        
        // Apply that new state
        dataSource?.apply(snapshot)
        headerView?.progress = progress
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(withId: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue = reminder.isComplete ? completedReminderValue : notCompletedReminderValue
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    
    func updateReminder(_ reminder: Reminder) {
        do {
            try reminderStore.save(reminder)
            let index = reminders.indexOfReminder(withId: reminder.id)
            reminders[index] = reminder
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility")
        // By default, closures create a strong reference to external values that you use inside them. Specifying a weak reference to the view controller prevents a retain cycle.
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(withId: reminder.id)
            return true
        }
        
        return action
    }
    
    func completeReminder(withId id: Reminder.ID) {
        var reminder = reminder(withId: id)
        reminder.isComplete.toggle()
        updateReminder(reminder)
        updateSnapshot(reloading: [id])
    }
    
    func addReminder(_ reminder: Reminder) {
        // Make a copy (reminder was passed by reference)
        var reminder = reminder
        
        do {
            let idFromStore = try reminderStore.save(reminder)
            reminder.id = idFromStore
            reminders.append(reminder)
        // We ignore the access denied error
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    func deleteReminder(withId id: Reminder.ID) {
        do {
            try reminderStore.delete(with: id)
            let index = reminders.indexOfReminder(withId: id)
            reminders.remove(at: index)
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
        
    
    func prepareReminderStore() {
        // To call a function marked as async from a sync function, you need to establish a Task context
        Task {
            do {
                try await reminderStore.requestAccess()
                reminders = try await reminderStore.readAll()
                NotificationCenter.default.addObserver(self, selector: #selector(self.eventStoreChanged(_:)), name: .EKEventStoreChanged, object: nil)
            } catch TodayError.accessDenied, TodayError.accessRestricted {
                #if DEBUG
                reminders = Reminder.sampleData
                #endif
            } catch {
                showError(error)
            }
            updateSnapshot()
        }
    }
    
    func reminderStoreChanged() {
        Task {
            reminders = try await reminderStore.readAll()
            self.updateSnapshot(reloading: self.reminders.map({ $0.id }))
        }
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let highlightedImage = UIImage(systemName: "circle.circle", withConfiguration: symbolConfiguration)
        
        let button = ReminderDoneButton()
        button.id = reminder.id
        
        // #selector expects an Objective-C method
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage, for:.highlighted)
        
        return UICellAccessory.CustomViewConfiguration(
            customView: button,
            placement: .leading(displayed: .always)
        )
        
    }
    
    
}
