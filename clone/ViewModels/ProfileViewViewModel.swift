//
//  profileViewViewModel.swift
//  clone
//
//  Created by naveen-pt6301 on 11/01/23.
//
import Combine
import FirebaseStorageCombineSwift
import Foundation
import Firebase

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    
  private var subscriptions: Set<AnyCancellable> = []
    
    func retrieveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        databaseManager.shared.collectionUsers(retrieve: id)
            .sink{ [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
  
}
