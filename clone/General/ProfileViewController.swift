//
//  ProfileViewController.swift
//  clone
//
//  Created by naveen-pt6301 on 08/12/22.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .systemBlue
        navigationItem.title = "profile"
        
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        
        profileTableView.delegate = self
        profileTableView.dataSource  = self

        configureConstraints()
        bindViews()
        
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden  = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveUser()
    }
   
    private var isStatusBarHidden: Bool = true
    private lazy var headerView = profileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
    private var viewModel = ProfileViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
//    creating date
    func getCurrentShortDate() -> String {
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var DateInFormat = dateFormatter.string(from: todaysDate as Date)
        print("Date: \(DateInFormat)")
        return DateInFormat
    }
//
    private func bindViews(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            self?.headerView.profileUserNameLabel.text = user.userName
            self?.headerView.profileDisplayNameLabel.text = user.displayName
            self?.headerView.profileUserBioLabel.text = user.bio
//            self?.headerView.profileAvatarImageView.image = UIImage(named: user.avatarPath)
            self?.headerView.followersCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.profileUserJoinDateLabel.text = self?.getCurrentShortDate()
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            
        }.store(in: &subscriptions)
    }
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints  = false
        return tableview
    }()
   
    private func configureConstraints() {
        
       let  profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
       
        let statusBarConstraints = [
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 400 ? 40 : 20)
        ]
        
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yPosition = scrollView.contentOffset.y
        
        if yPosition>150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                [weak self] in self?.statusBar.layer.opacity = 1
            } completion: { _ in }
        }else if yPosition<0 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                [weak self] in self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
}
