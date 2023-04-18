//
//  ProfileDataFormViewController.swift
//  clone
//
//  Created by naveen-pt6301 on 06/01/23.
//

import UIKit
import PhotosUI
import Firebase
import Combine

class ProfileDataFormViewController: UIViewController {
    
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
    
    @objc func didTapUploadAvatarImage(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private let viewModel = ProfileDataFormViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
// main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollview)
        isModalInPresentation = false
        
        scrollview.addSubview(titleLabel)
        scrollview.addSubview(avatarImageView)
        scrollview.addSubview(displayNameTextfield)
        scrollview.addSubview(usernameTextfield)
        scrollview.addSubview(userBiotextView)
        scrollview.addSubview(submitButton)
//        giving delegate = self , so that user can persorm his own actions
        userBiotextView.delegate = self
        usernameTextfield.delegate = self
        displayNameTextfield.delegate = self

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUploadAvatarImage)))
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        configureConstraints()
        bindViews()
    }
    
    @objc private func didTapSubmit(){
        viewModel.uploadAvatar()
//        TwitterUser.isUserOnboarded = true
    }
    
    private let scrollview: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           scrollView.alwaysBounceVertical = true
           scrollView.keyboardDismissMode = .onDrag
           return scrollView
       }()
       
       private let displayNameTextfield: UITextField = {
           let textField = UITextField()
           textField.translatesAutoresizingMaskIntoConstraints = false
           textField.keyboardType = .default
           textField.backgroundColor =  .secondarySystemFill
           textField.leftViewMode = .always
           textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
           textField.layer.masksToBounds = true
           textField.layer.cornerRadius = 8
           textField.attributedPlaceholder = NSAttributedString(string: "Display Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
           return textField
       }()
       
       
       private let usernameTextfield: UITextField = {
           let textField = UITextField()
           textField.translatesAutoresizingMaskIntoConstraints = false
           textField.keyboardType = .default
           textField.backgroundColor =  .secondarySystemFill
           textField.leftViewMode = .always
           textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
           textField.layer.masksToBounds = true
           textField.layer.cornerRadius = 8
           textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
           return textField
       }()
       
       
       private let titleLabel: UILabel = {
          
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Fill in you data"
           label.font = .systemFont(ofSize: 32, weight: .bold)
           label.textColor = .label
           return label
       }()
       
       
       private let avatarImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.clipsToBounds = true
           imageView.layer.masksToBounds = true
           imageView.layer.cornerRadius = 60
//           imageView.backgroundColor = .lightGray
           imageView.image = UIImage(systemName: "photo")
           imageView.tintColor = .gray
           imageView.isUserInteractionEnabled = true
           imageView.contentMode = .scaleAspectFill
           return imageView
       }()
       
       
       private let userBiotextView: UITextView = {
          
           let textView = UITextView()
           textView.translatesAutoresizingMaskIntoConstraints = false
           textView.backgroundColor = .secondarySystemFill
           textView.layer.masksToBounds = true
           textView.layer.cornerRadius = 8
           textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
           textView.text = "Tell the world about yourself"
           textView.textColor = .systemGray
           textView.font = .systemFont(ofSize: 16)
           return textView
       }()
       
       
       private let submitButton: UIButton = {
           let button = UIButton(type: .system)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.setTitle("Submit", for: .normal)
           button.tintColor = .white
           button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
           button.backgroundColor = .systemBlue
           button.layer.masksToBounds = true
           button.layer.cornerRadius = 25
           button.isEnabled = false
           return button
       }()

    @objc func didUpdateUsername(){
        viewModel.userName = usernameTextfield.text
        viewModel.validateProfileDataForm()
    }
    
    @objc func didUpdateDisplayName(){
        viewModel.displayName = displayNameTextfield.text
        viewModel.validateProfileDataForm()
    }
    
    private func bindViews(){
        usernameTextfield.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        displayNameTextfield.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        viewModel.$isFormValid.sink{ [weak self] buttonState in
            self?.submitButton.isEnabled = buttonState
//            print("buttonState : \(buttonState)")
        }.store(in: &subscriptions)
        
        viewModel.$isOnBoardingFinished.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        } .store(in: &subscriptions)

    }
    
    private func configureConstraints() {
           
           let scrollviewConstraints = [
               scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               scrollview.topAnchor.constraint(equalTo: view.topAnchor),
               scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ]
           
           
           let titleLabelConstraints = [
               titleLabel.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor),
               titleLabel.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 30)
           ]
           
           
           let avatarImageViewConstraints = [
              avatarImageView.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor),
              avatarImageView.heightAnchor.constraint(equalToConstant: 120),
              avatarImageView.widthAnchor.constraint(equalToConstant: 120),
              avatarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
           ]
           
           let displayNameTextfieldConstraints = [
               displayNameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               displayNameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               displayNameTextfield.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
               displayNameTextfield.heightAnchor.constraint(equalToConstant: 50)
           ]
           
           let usernameTextfieldConstraints = [
            usernameTextfield.leadingAnchor.constraint(equalTo: displayNameTextfield.leadingAnchor),
            usernameTextfield.trailingAnchor.constraint(equalTo: displayNameTextfield.trailingAnchor),
            usernameTextfield.topAnchor.constraint(equalTo: displayNameTextfield.bottomAnchor, constant: 20),
            usernameTextfield.heightAnchor.constraint(equalToConstant: 50)
           ]
           
           let userBiotextViewConstraints = [
               userBiotextView.leadingAnchor.constraint(equalTo: displayNameTextfield.leadingAnchor),
               userBiotextView.trailingAnchor.constraint(equalTo: displayNameTextfield.trailingAnchor),
               userBiotextView.topAnchor.constraint(equalTo: usernameTextfield.bottomAnchor, constant: 20),
               userBiotextView.heightAnchor.constraint(equalToConstant: 150)
           ]
           
           let submitButtonConstraints = [
               submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               submitButton.heightAnchor.constraint(equalToConstant: 50),
               submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
           ]
           
           NSLayoutConstraint.activate(scrollviewConstraints)
           NSLayoutConstraint.activate(titleLabelConstraints)
           NSLayoutConstraint.activate(avatarImageViewConstraints)
           NSLayoutConstraint.activate(displayNameTextfieldConstraints)
           NSLayoutConstraint.activate(usernameTextfieldConstraints)
           NSLayoutConstraint.activate(userBiotextViewConstraints)
           NSLayoutConstraint.activate(submitButtonConstraints)
       }
    
}

extension ProfileDataFormViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollview.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y-100), animated: true)
        if textView.textColor == .systemGray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if textView.text.isEmpty {
            textView.textColor = .systemGray
            textView.text = "Tell the world about yourself"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.bio = textView.text
        viewModel.validateProfileDataForm()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollview.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y-100), animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

extension ProfileDataFormViewController: PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self ){[weak self] object , error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                        self?.viewModel.imageData = image
//                        print("image data : ")
                        self?.viewModel.validateProfileDataForm()
                    }
                }
            }
        }
        
    }
}
