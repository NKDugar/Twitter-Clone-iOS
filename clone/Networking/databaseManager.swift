//
//  databaseManager.swift
//  clone
//
//  Created by naveen-pt6301 on 06/01/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class databaseManager{
    
    static let shared = databaseManager()
    
    let db = Firestore.firestore()
    let userPath: String = "users"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool,Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(userPath).document(twitterUser.id).setData(from: twitterUser)
            .map{ _ in  return true  }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retrieve id: String) -> AnyPublisher<TwitterUser , Error> {
        db.collection(userPath).document(id).getDocument()
            .tryMap { try $0.data(as: TwitterUser.self)  }
            .eraseToAnyPublisher()
    }
    
    func collectionUser(updateFields: [String : Any] , for id: String ) -> AnyPublisher<Bool,Error>{
        return db.collection(userPath).document(id).updateData(updateFields)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
}
