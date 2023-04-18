//
//  ProfileDataFormViewViewModel.swift
//  clone
//
//  Created by naveen-pt6301 on 08/01/23.
//

import Foundation
import Combine
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

final class ProfileDataFormViewViewModel: ObservableObject {

    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var userName: String?
    @Published var displayName: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String? = " "
    @Published var isOnBoardingFinished: Bool = false
    
    func validateProfileDataForm(){
        guard  let userName = userName ,
               userName.count > 2 ,
               let displayName = displayName,
               displayName.count > 2 ,
               let bio = bio ,
               bio.count > 2 ,
               imageData != nil else {
//            debugPrint("image data: \(imageData ?? UIImage())")
            isFormValid = false
            return
        }
        isFormValid = true
    }

//    func printingData(){
//        debugPrint(" username: \(userName ?? "unknown") , displayName: \(displayName ?? "unknown display name" ) , bio: \(bio ?? "unknown bio" ) , isFormValid: \(isFormValid)" )
//    }


    func uploadAvatar() {

        let randomID = UUID().uuidString
//        converting the imageData , which in binary format into JPEG data format , so when retrieving we will get a jpeg image , with modifications in quality
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }
        //         storage metadata helps to describe the type of data
        let metaData = StorageMetadata()
        //        setting the content type / fiile type
        metaData.contentType = "images/jpeg"

        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData)
            .flatMap({ metaData in
                StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                case .finished:
                    self?.updateUserData()
                }
            }receiveValue: { [weak self] url in
                self?.avatarPath = url.absoluteString
            }.store(in: &subscriptions)
    }

    func updateUserData(){
        guard let userName ,
              let displayName,
              let avatarPath ,
              let bio,
              let id = Auth.auth().currentUser?.uid else {
            print(" ----- updateUserData() failed ! ----- ")
            return
        }  
        print("userName: \(userName)")
        TwitterUser.isUserOnboarded = true
        let updatedFields: [String : Any] = [
            "userName" : userName,
            "displayName" : displayName,
            "avatarPath" : avatarPath ,
            "bio" : bio ,
            "isUserOnBoarded" : true
        ]
        databaseManager.shared.collectionUser(updateFields: updatedFields, for: id)
                   .sink { [weak self]  completion in
                       if case .failure(let error) = completion {
                           print(error.localizedDescription)
                           self?.error = error.localizedDescription
                       }
                   } receiveValue: { [weak self] onboardingState in
                       self?.isOnBoardingFinished = onboardingState
                       print(" isOnBoardingFinished: \(onboardingState) ")
                   }
            .store(in: &subscriptions)
    }
    
}

