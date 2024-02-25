//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Lee Sangoroh on 25/02/2024.
//

import UIKit

class GFButton: UIButton {
    
    //override the initializer only when customizing the default
    override init(frame: CGRect) {
        super.init(frame: frame)
        ///custom code
        
    }
    
    ///required when initializing button via storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure(){
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }

}
