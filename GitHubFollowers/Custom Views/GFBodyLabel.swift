//
//  GFBodyLabel.swift
//  GitHubFollowers
//
//  Created by Lee Sangoroh on 27/02/2024.
//

import UIKit

class GFBodyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment:NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    func configure() {
        /// lighter shade
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        /// enable shrinking
        adjustsFontSizeToFitWidth = true
        /// should shrink by 90% furthest
        minimumScaleFactor = 0.75
        /// how to truncate when label is longer than text provided
        lineBreakMode = .byWordWrapping
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
