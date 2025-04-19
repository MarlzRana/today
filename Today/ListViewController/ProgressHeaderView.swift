//
//  ProgressHeaderView.swift
//  Today
//
//  Created by Marlin Ranasinghe on 19/04/2025.
//

import UIKit

// UICollectionReusableView prevents this view from being deleted and made again everytime it disappers and appears on the screen
// Instead of being de-allocated from memory it is added to a "reuse queue" and popped off everytime it is back in view
class ProgressHeaderView: UICollectionReusableView {
    var progress: CGFloat = 0
    
    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    
    private func prepareSubviews() {
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        self.addSubview(containerView)
        
        // Turn off auto resizing
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Make the ProgressHeaderView and containerView square
        // Notice these are constraints defined between the same views
        // If the constraints are between different views, the common ancestor view is found and it is responsible for enforcing the constraint
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        
        // Center the container view in ProgressHeaderView
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Constrain the upper and lower views appropriately
        // Make sure that the upper view can only be from "the base of the lower view and up"
        upperView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        upperView.bottomAnchor.constraint(equalTo: self.lowerView.topAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // Add horizontal constraints to the upper and lower view
        upperView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Make the contrainer view have 85% the width+height(due to square constraint) of its parent
        // I.e here the common ancestor is self/ProgressHeaderView, hence, it is responsible for enforcing the constraint
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
    }
}
