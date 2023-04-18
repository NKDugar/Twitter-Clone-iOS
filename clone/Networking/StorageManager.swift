//
//  StorageManager.swift
//  clone
//
//  Created by naveen-pt6301 on 10/01/23.
//
import UIKit
import Foundation
import Firebase
import FirebaseStorage
import FirebaseStorageCombineSwift
import Combine

enum FireStorageError: Error{
    case invalidImageId
}

final class StorageManager {
    static let shared = StorageManager()
    
    let storage = Storage.storage()
     
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else {
            return Fail(error: FireStorageError.invalidImageId)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print("----getDownloadURL----")
            .print()
            .eraseToAnyPublisher()
    }
    
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        return storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .print("-----uploadProfilePhoto----")
            .print()
            .eraseToAnyPublisher()
    }
    
}
