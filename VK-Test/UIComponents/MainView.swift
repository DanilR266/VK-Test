//
//  MainView.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import UIKit

class MainView: UIView {
    private let size = Size.shared
    
    var buttonSortVoid: (()->())?
    var buttonSortNameVoid: (()->())?
    var buttonSortLanguageVoid: (()->())?
    var buttonSortRepoVoid: (()->())?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.backgroundColor = .clear
        activity.color = .white
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.widthAnchor.constraint(equalToConstant: size.width(25)).isActive = true
        activity.heightAnchor.constraint(equalToConstant: size.width(25)).isActive = true
        return activity
    }()
    
    lazy var buttonSort: UIButton = {
        let button = UIButton()
        button.setTitle(ConstantsString.sort, for: [])
        button.setTitleColor(.white, for: [])
        button.addTarget(self, action: #selector(buttonSortTap), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sortName: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonSortNameTap), for: .touchUpInside)
        button.backgroundColor = .customWhite
        button.setTitle(ConstantsString.name, for: [])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = size.height(36/2)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.black, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
      button.heightAnchor.constraint(equalToConstant: size.height(36)).isActive = true
        button.widthAnchor.constraint(equalToConstant: size.width(85)).isActive = true
        return button
    }()
    
    lazy var sortLanguage: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonSortLanguageTap), for: .touchUpInside)
        button.backgroundColor = .customWhite
        button.setTitle(ConstantsString.language, for: [])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = size.height(36/2)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.black, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: size.height(36)).isActive = true
        button.widthAnchor.constraint(equalToConstant: size.width(107)).isActive = true
        return button
    }()
    
    lazy var sortRepo: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonSortRepoTap), for: .touchUpInside)
        button.backgroundColor = .customWhite
        button.setTitle(ConstantsString.repo, for: [])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = size.height(36/2)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.black, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: size.height(36)).isActive = true
        button.widthAnchor.constraint(equalToConstant: size.width(85)).isActive = true
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.spacing = size.width(21)
        stack.axis = .horizontal
        stack.isUserInteractionEnabled = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    @objc func buttonSortTap() {
        buttonSortVoid?()
    }
    
    @objc func buttonSortNameTap() {
        buttonSortNameVoid?()
    }
    
    @objc func buttonSortLanguageTap() {
        buttonSortLanguageVoid?()
    }
    
    @objc func buttonSortRepoTap() {
        buttonSortRepoVoid?()
    }
    
    private func setupView() {
        addSubview(buttonSort)
        addSubview(stackView)
        addSubview(activityIndicator)
        stackView.addArrangedSubview(sortName)
        stackView.addArrangedSubview(sortLanguage)
        stackView.addArrangedSubview(sortRepo)
        
        NSLayoutConstraint.activate([
            
            activityIndicator.centerYAnchor.constraint(equalTo: buttonSort.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -size.width(35)),
            
            buttonSort.topAnchor.constraint(equalTo: topAnchor, constant: size.height(47)),
            buttonSort.leadingAnchor.constraint(equalTo: leadingAnchor, constant: size.width(35)),
            
            stackView.topAnchor.constraint(equalTo: buttonSort.bottomAnchor, constant: size.height(8)),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: size.width(26)),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -size.width(26)),
//            stackView.heightAnchor.constraint(equalToConstant: size.height(36)),
            
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.backgroundColor = .backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
