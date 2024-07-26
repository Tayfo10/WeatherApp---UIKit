//
//  WALabel.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 11.07.2024.
//

import UIKit

class WALabel: UILabel {
    
    init(text: String, fontSize: CGFloat, textAlignment: NSTextAlignment){
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.textAlignment = textAlignment
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
