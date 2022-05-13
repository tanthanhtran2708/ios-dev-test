//
//  NoteIconView.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/22/21.
//

import UIKit

class NoteIconView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let image = UIImage(named: "note") else { return }
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        
        imageView.setImageColor(color: .white)
        
        backgroundColor = UIColor(hexString: "#2B3236")
    }
}
