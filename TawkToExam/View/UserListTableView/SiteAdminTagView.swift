//
//  SiteAdminTagView.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/22/21.
//

import UIKit

class SiteAdminTagView: UIView {
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Admin"
        lbl.textColor = .white
        lbl.font = UIFont.preferredFont(forTextStyle: .footnote)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(hexString: "#FE421D")
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        layer.masksToBounds = true
        layer.cornerRadius = 3
    }
}
