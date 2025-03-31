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
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case(Section.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
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
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        dataSource?.apply(snapshot)
    }
}
