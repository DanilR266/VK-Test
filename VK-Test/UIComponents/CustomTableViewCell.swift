//
//  CustomTableViewCell.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    let size = Size.shared
    
    var goToGit: (()->())?
    
    lazy var unViewCell: UIView = {
        let view = UIView()
        view.backgroundColor = .customWhite
        view.layer.cornerRadius = size.height(21)
        view.layer.borderWidth = size.width(1)
        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ownerName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var repoName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var languageName: PaddedLabel = {
        let label = PaddedLabel()
        label.backgroundColor = .customGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = size.height(14/2)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: size.height(18)).isActive = true
        return label
    }()
    
    lazy var visibilityStatus: PaddedLabel = {
        let label = PaddedLabel()
        label.backgroundColor = .customGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = size.height(14/2)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: size.height(18)).isActive = true
        return label
    }()
    
    lazy var forksCount: PaddedLabel = {
        let label = PaddedLabel()
        label.backgroundColor = .customGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = size.height(14/2)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: size.height(18)).isActive = true
        return label
    }()
    
    lazy var viewOnGitButton: UIButton = {
        let button = UIButton()
        button.setTitle(ConstantsString.seeOnGit, for: [])
        button.setTitleColor(.customBlue, for: [])
        button.addTarget(self, action: #selector(buttonGitTap), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var iconCell: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = size.height(20)
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: size.width(62)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size.height(62)).isActive = true
        return imageView
    }()
    
    @objc func buttonGitTap() {
        print("Tap")
        goToGit?()
    }
    
    
    func configureCell(item: Item) {
        ownerName.text = item.owner.login
        repoName.text = item.name
        visibilityStatus.text = item.visibility
        languageName.text = item.language ?? ConstantsString.none
        forksCount.text = "\(ConstantsString.forks) \(item.forksCount)"
    }
    
    
    private func setupView() {
        contentView.addSubview(unViewCell)
        unViewCell.addSubview(ownerName)
        unViewCell.addSubview(repoName)
        unViewCell.addSubview(languageName)
        unViewCell.addSubview(visibilityStatus)
        unViewCell.addSubview(forksCount)
        unViewCell.addSubview(iconCell)
        unViewCell.addSubview(viewOnGitButton)
        
        NSLayoutConstraint.activate([
            
            unViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            unViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            unViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            unViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            iconCell.topAnchor.constraint(equalTo: unViewCell.topAnchor, constant: size.height(5)),
            iconCell.trailingAnchor.constraint(equalTo: unViewCell.trailingAnchor, constant: -size.height(5)),
            
            ownerName.topAnchor.constraint(equalTo: unViewCell.topAnchor, constant: size.height(10)),
            ownerName.leadingAnchor.constraint(equalTo: unViewCell.leadingAnchor, constant: size.height(13)),
            ownerName.trailingAnchor.constraint(equalTo: iconCell.leadingAnchor, constant: -5),
            ownerName.bottomAnchor.constraint(equalTo: repoName.topAnchor),
            
            repoName.topAnchor.constraint(equalTo: ownerName.bottomAnchor, constant: size.height(6)),
            repoName.leadingAnchor.constraint(equalTo: unViewCell.leadingAnchor, constant: size.height(13)),
            repoName.trailingAnchor.constraint(equalTo: iconCell.leadingAnchor, constant: -5),
            repoName.bottomAnchor.constraint(equalTo: visibilityStatus.topAnchor),
            
            visibilityStatus.leadingAnchor.constraint(equalTo: unViewCell.leadingAnchor, constant: size.width(14)),
            visibilityStatus.topAnchor.constraint(equalTo: repoName.bottomAnchor, constant: size.height(5)),
            visibilityStatus.bottomAnchor.constraint(equalTo: viewOnGitButton.bottomAnchor, constant: -size.height(14)),
            
            languageName.centerYAnchor.constraint(equalTo: visibilityStatus.centerYAnchor),
            languageName.leadingAnchor.constraint(equalTo: visibilityStatus.trailingAnchor, constant: size.width(10)),
            languageName.bottomAnchor.constraint(equalTo: viewOnGitButton.bottomAnchor, constant: -size.height(14)),
            
            forksCount.centerYAnchor.constraint(equalTo: visibilityStatus.centerYAnchor),
            forksCount.leadingAnchor.constraint(equalTo: languageName.trailingAnchor, constant: size.width(10)),
            forksCount.bottomAnchor.constraint(equalTo: viewOnGitButton.bottomAnchor, constant: -size.height(14)),
            
            viewOnGitButton.leadingAnchor.constraint(equalTo: unViewCell.leadingAnchor, constant: size.width(14)),
            viewOnGitButton.topAnchor.constraint(equalTo: visibilityStatus.bottomAnchor, constant: size.height(4)),
            viewOnGitButton.bottomAnchor.constraint(equalTo: unViewCell.bottomAnchor, constant: -size.height(10))
        ])
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
