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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case(_, Row.header(let title)):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = title
            cell.contentConfiguration = contentConfiguration
        case(Section.view, _):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = text(for: row)
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguration.image = row.image
            cell.contentConfiguration = contentConfiguration
        default:
            fatalError("Unexpected combination of section and row")
        }
        
        cell.tintColor = .todayPrimaryTint
    }
    
    func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.view])
        snapshot.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: Section.view)
        dataSource?.apply(snapshot)
    }
    
    func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.title, Section.date, Section.notes])
        snapshot.appendItems([.header(Section.title.name)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name)], toSection: .notes)
        dataSource?.apply(snapshot)
    }
}
