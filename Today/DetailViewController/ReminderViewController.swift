//
//  ReminderViewController.swift
//  Today
//
//  Created by Marlin Ranasinghe on 19/03/2025.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    var reminder: Reminder
    var dataSource: DataSource?
    
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
    
    // This is a lifecycle method that is triggered when the view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistraion = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: <#T##UICollectionView#>) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistraion, for: indexPath, item: itemIdentifier)
        }
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
