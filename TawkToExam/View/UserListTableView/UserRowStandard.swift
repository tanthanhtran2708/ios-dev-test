//
//  UserRowStandard.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/22/21.
//

import UIKit

class UserRowStandard: UITableViewCell, UserRowProtocol {
    var siteAdminTagView: SiteAdminTagView = {
        let siteAdmin = SiteAdminTagView()
        siteAdmin.translatesAutoresizingMaskIntoConstraints = false
        siteAdmin.isHidden = true
        return siteAdmin
    }()
    
    var userImageView: CachingImageView = {
        let imageView = CachingImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var userLoginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userDetails: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var noteView: NoteIconView = {
        let noteView = NoteIconView()
        noteView.layer.masksToBounds = true
        noteView.layer.cornerRadius = 8
        noteView.translatesAutoresizingMaskIntoConstraints = false
        return noteView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCommonViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCommonViews()
    }
    
    func setupCellInfo(for user: UserRowData) {
        userLoginNameLabel.text = user.login
        userDetails.text = user.type
        siteAdminTagView.isHidden = !user.siteAdmin
    }
}
