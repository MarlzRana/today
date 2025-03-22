//
//  ViewController.swift
//  Today
//
//  Created by Marlin Ranasinghe on 15/03/2025.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource?
    var reminders: [Reminder] = Reminder.sampleData

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // Presentation
        // We may have to register a cell multiple times with its configuration
        // UIKit makes efficient memory use when presenting cells
        // One measure used is garbage collecting cells that are no longer visible on the screen (after scrolling)
        // However the user may scroll up
        // Hence we may have to re-register a (new) cell back with its configuration
        let cellRegistration = UICollectionView.CellRegistration(handler: self.cellRegistrationHandler)
        
        // Data
        // The collection view was set with a list layout
        // Hence we are provided cells
        // Per cell we wire up a data element to it
        // We define how we present that cell by registering that cell with a configuration that defines the presentation and what data to use
        // https://developer.apple.com/tutorials/app-dev-training/adopting-collection-views
        self.dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    // Triggered when click on a cell
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        // Stops the cell items from appearing as selected on click (as we just trying to transition to another view)
        return false
    }
    
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // Layout
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }


}

