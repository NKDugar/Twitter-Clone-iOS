//
//  TwitterUser.swift
//  clone
//
//  Created by naveen-pt6301 on 06/01/23.
//

import Foundation
import Firebase
import FirebaseAuth

struct TwitterUser: Codable {
    let id: String
    var displayName: String = ""
    var userName: String = ""
    var followersCount: Int = 0
    var followingCount: Int = 0
    var createdOn: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    static var isUserOnboarded: Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
    
}
