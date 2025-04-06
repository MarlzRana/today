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
    
    var completedReminderValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var notCompletedReminderValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        // Create some new state
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(self.reminders.map {$0.id})
        
        // If we have modified some reminders (but their ids have stayed constant), let's explicitly ask UIKit to reload them
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        
        // Apply that new state
        dataSource?.apply(snapshot)
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
        let index = reminders.indexOfReminder(withId: reminder.id)
        reminders[index] = reminder
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
        reminders.append(reminder)
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
