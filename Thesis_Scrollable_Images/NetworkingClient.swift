//
//  NetworkingClient.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//


import Foundation
import Alamofire
import Firebase
import SwiftUI

class NetworkingClient {
    let url = "https://api.unsplash.com/photos/?client_id=Bl6VoiuFBk4rEg-aRjLhyphcDrw_2Tve9lBxsvNo3A0"
    var urlArray = [URL]()
    
    
    typealias CompletionHandler = (Result<[URL], AFError>) -> Void
    
    func execute(completionHandler: @escaping CompletionHandler){
        print("N.REQUEST1")
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let starsRef = storageRef.child("images/copenhagen.jpg")
        let images = starsRef.parent()
        images?.listAll(completion: { result, error in
            print("N.REQUEST2")


            let referenceURI = result.items


            
            for reference in referenceURI {
                print("N.REQUEST3")


                
                // Fetch the download URL
               reference.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print(error)
                    } else {
                        if let url = url {
                            print("N.REQUEST4")

                            self.urlArray.append(url)
                            completionHandler(.success(self.urlArray))

                        }
                    }
                }
            }
            
            /*if self.urlArray.count > 0 {
                completionHandler(.success(self.urlArray))
                print("N.REQUEST5")

            } */
            
        })
    }
}
