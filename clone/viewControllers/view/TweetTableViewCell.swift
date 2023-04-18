//
//  TweetTableViewCell.swift
//  clone
//
//  Created by naveen-pt6301 on 02/12/22.
//

import UIKit


protocol TweetTableViewCellDelegate: AnyObject{
    
    func tweetTableViewCellDidTapReply()
    func tweetTableViewCellDidTapLike()
    func tweetTableViewCellDidTapRetweet()
    func tweetTableViewCellDidTapShare()
    
}

class TweetTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //        adding views
        contentView.addSubview(AvatarImage)
        contentView.addSubview(userName)
        contentView.addSubview(displayName)
        contentView.addSubview(tweetTextContentLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(replyButton)
        contentView.addSubview(shareButton)
        
        //         calling functions
        configureConstraints()
        configureButtons()
    }
    
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    
    static let identifier = "TweetTableViewCell"
    private let actionSpacing: CGFloat = 60
    weak var delegate: TweetTableViewCellDelegate?
    
     var AvatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode  = .scaleAspectFit
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds  = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    
    var displayName: UILabel = {
        let label = UILabel()
        label.text = "displayName"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userName: UILabel = {
        let label = UILabel()
        label.text = "@userName"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tweetTextContentLabel: UILabel = {
        let label = UILabel()
        label.text = " welcome to my twitter and learning to build it using  swift UI kit components !! lets see how long we go ! "
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "likeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray2
        return button
    }()
    
    private let replyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "replyButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray2
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "retweetButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray2
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "shareButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray2
        return button
    }()

    
    @objc func tweetTableViewCellDidTapLike(){
        delegate?.tweetTableViewCellDidTapLike()
//        debugPrint("like")
    }

    @objc func tweetTableViewCellDidTapRetweet(){
        delegate?.tweetTableViewCellDidTapRetweet()
//        debugPrint("retweet")
    }

    @objc func tweetTableViewCellDidTapReply(){
        delegate?.tweetTableViewCellDidTapReply()
//        debugPrint("reply")
    }

    @objc func tweetTableViewCellDidTapShare(){
        delegate?.tweetTableViewCellDidTapShare()
//        debugPrint("share")
    }
    
    private func configureButtons(){
        
        likeButton.addTarget(self, action: #selector(tweetTableViewCellDidTapLike), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(tweetTableViewCellDidTapReply), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(tweetTableViewCellDidTapRetweet), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(tweetTableViewCellDidTapShare), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        
        
        let avatarImageViewConstraints = [
            AvatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            AvatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            AvatarImage.heightAnchor.constraint(equalToConstant: 50),
            AvatarImage.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let displayNameViewConstraints = [
            displayName.leadingAnchor.constraint(equalTo: AvatarImage.trailingAnchor, constant: 20),
            displayName.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 20) ,
            ]
        
        let userNameViewConstraints = [
            userName.leadingAnchor.constraint(equalTo: displayName.trailingAnchor,constant: 10),
            userName.centerYAnchor.constraint(equalTo: displayName.centerYAnchor)
        ]
        
        let tweetTextContentLableConstraints = [
            tweetTextContentLabel.leadingAnchor.constraint(equalTo: displayName.leadingAnchor ),
            tweetTextContentLabel.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: 10),
            tweetTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15 )
        ]
        
        
        let replyButtonViewConstraints = [
            replyButton.leadingAnchor.constraint(equalTo: tweetTextContentLabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: tweetTextContentLabel.bottomAnchor , constant: 10),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -15)
        ]
        
        let retweetButtonViewConstraints = [
            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: actionSpacing),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        
        let likeButtonViewConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: actionSpacing) ,
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        
        let shareButtonViewConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(avatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameViewConstraints)
        NSLayoutConstraint.activate(userNameViewConstraints)
        NSLayoutConstraint.activate(tweetTextContentLableConstraints)
        NSLayoutConstraint.activate(likeButtonViewConstraints)
        NSLayoutConstraint.activate(replyButtonViewConstraints)
        NSLayoutConstraint.activate(retweetButtonViewConstraints)
        NSLayoutConstraint.activate(shareButtonViewConstraints)
        
    }
   
}
