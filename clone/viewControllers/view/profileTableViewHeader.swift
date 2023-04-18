//
//  profileHeaderView.swift
//  clone
//
//  Created by naveen-pt6301 on 09/12/22.
//

import UIKit

class profileTableViewHeader: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .systemBlue
        
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(profileDisplayNameLabel)
        addSubview(profileUserNameLabel)
        addSubview(profileUserBioLabel)
        addSubview(joiningDateCalendarImageView)
        addSubview(profileUserJoinDateLabel)
        addSubview(followingTextLabel)
        addSubview(followingCountLabel)
        addSubview(followersTextLabel)
        addSubview(followersCountLabel)
        addSubview(sectionStack)
        configureConstraints()
        configureStackButtons()
    }
    
    let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        imageView.image = UIImage(named: "mountains")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var profileAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints  = false
//        imageView.backgroundColor = .yellow
//        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var profileDisplayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "displayName"
        label.textColor = .label
//        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    var profileUserNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "userName"
        label.textColor = .label
//        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
//        label.clipsToBounds = true
        return label
    }()
    
    var profileUserBioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "I am a developer "
//        label.backgroundColor = .white
        label.textColor = .label
        
        return label
    }()
    
    let joiningDateCalendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor  = .label
        imageView.image = UIImage(systemName: "calendar" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var profileUserJoinDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "9 dec 2022"
//        label.backgroundColor = .white
        label.textColor = .label
        return label
    }()
    
    var followersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "555"
        label.textColor = .label
        label.font  = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    var followersTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Followers"
        label.textColor = .secondaryLabel
        return label
    }()
    
    var followingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "55"
        label.font  = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()
    
    var followingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    private enum SectionTabs: String  {
        case Tweets = "Tweets"
        case TweetsAndReplies = "Tweets and Replies"
        case Media = "Media"
        case Likes = "Likes"
        
        var index: Int {
            switch self {
            case .Tweets:
                return 0
            case .TweetsAndReplies:
                return 1
            case .Media:
                return 2
            case .Likes:
                return 3
            default:
                return 0
            }
        }
    }
    
    
   
    private var tab: [UIButton] = ["Tweets","Tweets and Replies","Media","Likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints  = false
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.tintColor = .label
            return button
        }
    
//    to use a property eventhough it is not initialised before , we can do it by making it a lazy var **
    private lazy var  sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tab)
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        stackView.distribution = .equalSpacing
        stackView.alignment  = .center
        stackView.axis = .horizontal
//        stackView.backgroundColor = .systemPink
        return stackView
    }()
    
    private func configureStackButtons(){
//        we are using a tuple type because an enumerate return s value in pair
        
        for (i, button1) in sectionStack.arrangedSubviews.enumerated(){
            guard let button = button1 as? UIButton else { return }
            
            if (i == selectedTab) {
                button1.tintColor = .label
            }else{
                button1.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTapButtons(_: )), for: .touchUpInside)
        }
    }
    
    private var selectedTab: Int = 0 {
        didSet {
            for i in 0 ..< tab.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut){
                    [weak self] in self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedTab ?.label : .secondaryLabel
                }completion: { _ in  }
            }
        }
    }
    
    @objc private func didTapButtons(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? " ")
        guard let label  = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.Tweets.rawValue:
            selectedTab =  0
        case SectionTabs.TweetsAndReplies.rawValue:
            selectedTab = 1
        case SectionTabs.Media.rawValue:
            selectedTab = 2
        case SectionTabs.Likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    private func configureConstraints(){
        
        let profileHeaderImageViewConstraints = [
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let profileAvatarImageViewConstraints = [
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor,constant: 20),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let profileDisplayNameLabelConstraints = [
            profileDisplayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            profileDisplayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 10)
        ]
        
        let profileUserNameLabelConstraints = [
            profileUserNameLabel.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor),
            profileUserNameLabel.topAnchor.constraint(equalTo: profileDisplayNameLabel.bottomAnchor,constant: 5)
        ]
        
        let profileUserBioLabelConstraints = [
            profileUserBioLabel.topAnchor.constraint(equalTo: profileUserNameLabel.bottomAnchor, constant: 5),
            profileUserBioLabel.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor),
            
        ]
        
        let joiningDateCalendarImageViewConstraints = [
            joiningDateCalendarImageView.topAnchor.constraint(equalTo: profileUserBioLabel.bottomAnchor , constant: 5),
            joiningDateCalendarImageView.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor)
        ]
        
        let profileUserJoinDateLabelViewConstraints = [
            profileUserJoinDateLabel.leadingAnchor.constraint(equalTo: joiningDateCalendarImageView.trailingAnchor ,constant: 2),
            profileUserJoinDateLabel.topAnchor.constraint(equalTo: profileUserBioLabel.bottomAnchor, constant: 5)
        ]
        
         let followingCountLabelConstraints = [
            followingCountLabel.topAnchor.constraint(equalTo: profileUserJoinDateLabel.bottomAnchor,constant: 5),
            followingCountLabel.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor)
         ]
      
        let followingTextLabelConstraints = [
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor,constant: 3),
            followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
       
        let followersTextLabelConstraints = [
            followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor,constant: 3),
            followersTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let followersCountLabelConstraints = [
            followersCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor,constant: 8),
            followersCountLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let sectionStackConstraints = [
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor,constant: 3),
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionStack.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraints)
        NSLayoutConstraint.activate(profileDisplayNameLabelConstraints)
        NSLayoutConstraint.activate(profileUserNameLabelConstraints)
        NSLayoutConstraint.activate(profileUserBioLabelConstraints)
        NSLayoutConstraint.activate(joiningDateCalendarImageViewConstraints)
        NSLayoutConstraint.activate(profileUserJoinDateLabelViewConstraints)
        NSLayoutConstraint.activate(followingTextLabelConstraints)
        NSLayoutConstraint.activate(followingCountLabelConstraints)
        NSLayoutConstraint.activate(followersTextLabelConstraints)
        NSLayoutConstraint.activate(followersCountLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)
        
    }
    
}
