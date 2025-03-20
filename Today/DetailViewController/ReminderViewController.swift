//
//  ReminderViewController.swift
//  Today
//
//  Created by Marlin Ranasinghe on 19/03/2025.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    var reminder: Reminder
    
    init(reminder: Reminder) {
        self.reminder = reminder
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        super.init(collectionViewLayout: listLayout)
    }
    
    // Notice the question mark
    // This is a failable initializer
    // We don't need a failable initializer hence we stub it out    b
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .title: return reminder.title
        case .date: return reminder.dueDate.dayText
        case .time: return reminder.dueDate.timeText
        case .notes: return reminder.notes
        }
    }
}
