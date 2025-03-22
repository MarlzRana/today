//
//  ReminderViewController+DataSource.swift
//  Today
//
//  Created by Marlin Ranasinghe on 20/03/2025.
//

import UIKit

extension ReminderViewController {
    // Generic arguments (for both)
    // "Int" specifies that you are going to use Ints to specify/differentiate the sections
    // "Row" specified that you are going to use Rows to specify/differentiate the content
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Row>
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        // Adjust the cell's configuration
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        
        // Apply it back to the cell
        cell.contentConfiguration = contentConfiguration
        
        cell.tintColor = .todayPrimaryTint
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([Row.title, Row.date, Row.time, Row.notes], toSection: 0)
        dataSource?.apply(snapshot)
    }
}
