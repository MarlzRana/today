//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Marlin Ranasinghe on 16/03/2025.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
        let reminder = Reminder.sampleData[indexPath.item]
        var contentConfiguratiion = cell.defaultContentConfiguration()
        contentConfiguratiion.text = reminder.title
        contentConfiguratiion.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguratiion.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguratiion
        
        var backgroundConfiguration = UIBackgroundConfiguration.listCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    
}
