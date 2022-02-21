//
//  NetworkingClient.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//
import Foundation
import Firebase

class NetworkingClient {
    var urlArray = [URL]()
    
    typealias CompletionHandler = (Result<[URL], Error>) -> Void
    func execute(completionHandler: @escaping CompletionHandler){
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let starsRef = storageRef.child("images/IMG-20200508-WA0008.jpeg")
        let images = starsRef.parent()
        images?.listAll(completion: { result, error in
            let referenceURI = result.items
            
            for reference in referenceURI {
                // Fetch the download URL
               reference.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print(error)
                    } else {
                        if let url = url {
                            self.urlArray.append(url)
                            completionHandler(.success(self.urlArray))
                        }
                    }
                }
            }
        })
    }
}
