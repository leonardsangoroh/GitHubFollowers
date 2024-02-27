//
//  GFTitleLabel.swift
//  GitHubFollowers
//
//  Created by Lee Sangoroh on 27/02/2024.
//

import UIKit

class GFTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment:NSTextAlignment, fontSize:CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    func configure() {
        /// black in light mode - white in light mode
        textColor = .label
        /// enable shrinking
        adjustsFontSizeToFitWidth = true
        /// should shrink by 90% furthest
        minimumScaleFactor = 0.9
        /// how to truncate when label is longer than text provided
        lineBreakMode = .byTruncatingTail
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
