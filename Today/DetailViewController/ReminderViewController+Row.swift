//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Marlin Ranasinghe on 19/03/2025.
//

import UIKit

extension ReminderViewController {
    enum Row: Hashable {
        case title
        case date
        case time
        case notes
        
        var imageName: String? {
            switch self {
            case .date: return "calendar.circle"
            case .time: return "clock"
            case .notes: return "square.and.pencil"
            default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName else { return nil }
            
            let imgConfiguration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: imgConfiguration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .title: .headline
            default: .subheadline
            }
        }
    }
}
