//
//  TextViewContentView.swift
//  Today
//
//  Created by Marlin Ranasinghe on 31/03/2025.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
    }
    
    var textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init (_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
        addPinnedSubview(textView, height: 200)
        textView.backgroundColor = nil
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = self
    }
}

extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        configuration.onChange(textView.text)
    }
}


extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}
