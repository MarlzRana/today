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
    static var elementKind: String { UICollectionView.elementKindSectionHeader }
    
    var progress: CGFloat = 0 {
        didSet {
            // Everytime we update progress, invalidate the current layout and trigger an update
            self.setNeedsLayout()
            
            heightConstraint?.constant = progress * self.bounds.height
            // Without the below line we get no animation when progress changes
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
    
    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private var heightConstraint: NSLayoutConstraint?
    private var valueFormat: String {
        NSLocalizedString("%d percent", comment: "progress percentage value format")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = NSLocalizedString("Progress", comment: "Progress view accessibility")
        self.accessibilityTraits.update(with: .updatesFrequently)
    }
    
    // init?(coder:) is needed if you are loading from a storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.accessibilityValue = String(format: valueFormat, Int(progress * 100.0))
        heightConstraint?.constant = progress * bounds.width
        // Why does this need to be here? (Experiment moving this around)
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
    
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
        
        // Define the constraint that will control the lower view height (and in turn the upper view will move inversely due to prior constraints)
        heightConstraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        
        // Assign background colors to the views
        self.backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = .todayProgressUpperBackground
        lowerView.backgroundColor = .todayProgressLowerBackground
    }
}
