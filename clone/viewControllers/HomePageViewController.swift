//
//  HomePageViewController.swift
//  clone
//
//  Created by naveen-pt6301 on 29/11/22.
//

import UIKit
import FirebaseAuth
import Combine

class HomePageViewController: UIViewController  {
    
    private var  viewModel = HomeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
//     main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(timelineTableView)
        timelineTableView.delegate  = self
        timelineTableView.dataSource = self
        timelineTableView.frame = view.frame
        
        configureNavigationView()
        bindViews()
        print(subscriptions)
        
    }
// --------
//    @Published var user: TwitterUser?
//    @Published var error: String?
//
//    func retrieveUser(){
//        guard let id = Auth.auth().currentUser?.uid else { return }
//        databaseManager.shared.collectionUsers(retrieve: id)
//            .sink{ [weak self] completion in
//                if case .failure(let error) = completion {
//                    self?.error = error.localizedDescription
//                }
//            }receiveValue: { [weak self] user in
//                self?.user = user
//            }
//            .store(in: &subscriptions)
//    }
//    ----------
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame  = view.frame
    }
    
    private func configureNavigationView() {
        
        let size : CGFloat = 36
        
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        let logoImage = UIImage(named: "twitterLogo")
        logoImageView.image = logoImage
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfileImage))
//        logout button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
        
    }
    
    @objc private func didTapSignOut(){
        try?Auth.auth().signOut()
        handleAuthentication()
    }
    
    @objc private func didTapProfileImage(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnBoardingViewController())
            vc.modalPresentationStyle = .fullScreen
           present(vc, animated: true)
        }
    }
    
// closure
        private let timelineTableView: UITableView = {
            let tableView =  UITableView()
            tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
            return tableView
        }()
    
//    things which should appear on activation of this controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retrieveUser()
    }
    
    func completeUserOnBoarding(){
        let vc = ProfileDataFormViewController()
//        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
  
    func bindViews() {
            viewModel.$user.sink { [weak self] user in
                guard let user = user else { return }
                print(user)
                if !TwitterUser.isUserOnboarded {
                    self?.completeUserOnBoarding()
                }
            }
            .store(in: &subscriptions)
        }
    
}

extension HomePageViewController: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
}

extension HomePageViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        debugPrint("reply")
    }

    func tweetTableViewCellDidTapLike() {
        debugPrint("like")
    }

    func tweetTableViewCellDidTapRetweet() {
        debugPrint("retweet")
    }

    func tweetTableViewCellDidTapShare() {
        debugPrint("share")
    }
}
