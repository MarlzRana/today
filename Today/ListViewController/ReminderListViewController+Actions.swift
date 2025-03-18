//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Marlin Ranasinghe on 18/03/2025.
//

import UIKit

extension ReminderListViewController {
    
    // The @objc annotation makes the below method available to Objective-C code
    // We need this to attach this method to our custom button
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
}
