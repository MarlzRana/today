//
//  ReminderViewController+Section.swift
//  Today
//
//  Created by Marlin Ranasinghe on 22/03/2025.
//

import Foundation

extension ReminderViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        var name: String {
            switch self {
            case .view: return ""
            case .title: return NSLocalizedString("Title", comment: "Title section name")
            case .date: return NSLocalizedString("Date", comment: "Date section name")
            case .notes: return NSLocalizedString("Notes", comment: "Notes section name")
            }
        }
    }
    
    // In view mode, all items are displayed in section 0. In editing mode, the title, date, and notes are separated into sections 1, 2, and 3, respectively.
    // Enum:
    // View mode:
    // .view indexPath.section: 0 enumValue: 0 sectionNumber: 0
    // Edit mode:
    // .title indexPath.section: 0 enumValue: 1 sectionNumber: 1
    // .date indexPath.section: 1 enumValue: 2 sectionNumber: 2
    // .notes indexPath.section: 2 enumValue: 3 sectionNumber: 3
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
