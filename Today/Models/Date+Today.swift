//
//  Date+Today.swift
//  Today
//
//  Created by Marlin Ranasinghe on 16/03/2025.
//

// NSLocalizedString enables use an English representation of a string and get it to convert dynamically depending on the users locale settings
// We have to provide these localizations though in advance - it doesn't do the translation automatically for us
// Only the selection of what locale string to use is dynamic
// It is only for translation (nothing to do with datetime localization)

import Foundation

extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        }
        
        let dateText = formatted(.dateTime.month(.abbreviated).day())
        let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
        return String(format: dateAndTimeFormat, dateText, timeText)
    }
    
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        }
        
        return formatted(.dateTime.month().day().weekday(.wide))
    }
    
    var timeText: String {
        return formatted(date: .omitted, time: .shortened)
    }
}
