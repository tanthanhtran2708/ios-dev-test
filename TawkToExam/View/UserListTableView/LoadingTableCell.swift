//
//  LoadingTableCell.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//

import UIKit 

class LoadingTableCell: UITableViewCell {
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupActivityIndicator()
        selectionStyle = .none
    }
    
    private func setupActivityIndicator() {
        addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func animateIndicator(_ shouldAnimate: Bool) {
        if shouldAnimate {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}
