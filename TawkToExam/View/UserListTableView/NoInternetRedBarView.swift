//
//  NoInternetRedBarView.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//

import UIKit

class NoInternetRedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.red.withAlphaComponent(0.7)
        let label = UILabel()
        label.textColor = .white
        label.text = "No internet connection"
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

