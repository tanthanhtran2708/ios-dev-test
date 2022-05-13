//
//  UserRowProtocol.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//
import UIKit

protocol UserRowProtocol where Self: UITableViewCell {
    var userImageView: CachingImageView { get set }
    var siteAdminTagView: SiteAdminTagView { get set }
    var userLoginNameLabel: UILabel { get set }
    var userDetails: UILabel { get set }
    var noteView: NoteIconView { get set }
    func setupCellInfo(for user: UserRowData)
}

extension UserRowProtocol {    
    func setupCommonViews() {
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.distribution = .fill
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userImageView)
        addSubview(textStackView)
        
        textStackView.addArrangedSubview(userLoginNameLabel)
        textStackView.addArrangedSubview(userDetails)
        addSubview(siteAdminTagView)
        siteAdminTagView.isHidden = true
        
        
        addSubview(noteView)
        noteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        noteView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        noteView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        noteView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        noteView.isHidden = true
        
        let siteAdminConstraints = [
            siteAdminTagView.leadingAnchor.constraint(equalTo: userDetails.trailingAnchor, constant: 5),
            siteAdminTagView.centerYAnchor.constraint(equalTo: userLoginNameLabel.centerYAnchor),
            siteAdminTagView.widthAnchor.constraint(equalToConstant: 50),
            siteAdminTagView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let imageSquareHeight: CGFloat = 56
        let imageConstraints = [
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userImageView.heightAnchor.constraint(equalToConstant: imageSquareHeight),
            userImageView.widthAnchor.constraint(equalToConstant: imageSquareHeight),
        ]
        userImageView.layer.cornerRadius = imageSquareHeight/2
        
        
        let stackViewConstraints = [
            textStackView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            textStackView.heightAnchor.constraint(equalTo: userImageView.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(siteAdminConstraints + imageConstraints + stackViewConstraints)
    }
    
    func setNoteIconVisibility(to isVisible: Bool) {
        noteView.isHidden = !isVisible
    }
}
