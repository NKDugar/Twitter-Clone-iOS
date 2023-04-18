//
//  OnBoardingViewController.swift
//  clone
//
//  Created by naveen-pt6301 on 20/12/22.
//

import UIKit

class OnBoardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor  = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(createAccountButton)
        view.addSubview(promptLabel)
        view.addSubview(loginButton)
        
        configureConstraints()
        configureButtons()
    }
 
    private let welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "see whats happening in the world right now"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font  = .systemFont(ofSize: 32 , weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24 , weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "already have an account?"
        label.textColor = .label
        label.font  = .systemFont(ofSize: 14 , weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14 , weight: .bold)
        return button
    }()
    
    @objc func didTapLoginButton(){
        let vc =  LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "Login"
    }
    
    @objc func didTapCreateAccountButton(){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureButtons(){
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
    }
    
    private func configureConstraints(){
        let welcomeLabelConstraints = [
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -20)
        ]
        
        let createAccountButtonConstraints = [
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor,constant: 20),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor,constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60)
        ]
        
        let loginButtonConstraints = [
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor,constant: 10),
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor)
        ]
        
        
        NSLayoutConstraint.activate(welcomeLabelConstraints)
        NSLayoutConstraint.activate(createAccountButtonConstraints)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        
    }
}
