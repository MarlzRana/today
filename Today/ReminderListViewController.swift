//
//  ViewController.swift
//  Today
//
//  Created by Marlin Ranasinghe on 15/03/2025.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource?

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
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let reminder = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        // Data
        // The collection view was set with a list layout
        // Hence we are provided cells
        // Per cell we wire up a data element to it
        // We define how we present that cell by registering that cell with a configuration that defines the presentation and what data to use
        // https://developer.apple.com/tutorials/app-dev-training/adopting-collection-views
        self.dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        // Create some new state
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map({ $0.title }))
        
        // Apply that new state
        dataSource?.apply(snapshot)
        
        collectionView.dataSource = dataSource
    }
    
    
    // Layout
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }


}

