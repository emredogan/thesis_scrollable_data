//
//  NetworkingClient.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//
import Foundation
import Firebase
import Kingfisher

class NetworkingClient {
    var imageSizeString = "632kb"
    var shouldDownload = true

    
    init(size: String?) {
        imageSizeString = size ?? "632kb"
        urlArray.removeAll()
    }
    
    var urlArray = [URL]()
    var images = [UIImage]()

    let numberOfPicturesToDownload = 30
    
    typealias CompletionHandlerURL = (Result<[URL], Error>) -> Void
    typealias CompletionHandlerImage = (Result<[UIImage], Error>) -> Void

    
    func execute(completionHandler: @escaping CompletionHandlerURL){
        let trace = Performance.startTrace(name: "Downloading urls")

        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let imagesRef = storageRef.child(imageSizeString)
        imagesRef.listAll(completion: { result, error in
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
                            if(self.urlArray.count == self.numberOfPicturesToDownload) {
                                trace?.stop()
                                completionHandler(.success(self.urlArray))
                                return
                            }
                        }
                    }
                }
            }
        })
    }
    
    func retrieveImage(element: URL, currentSize: Int, completionHandler: @escaping CompletionHandlerImage) {
        FirebaseTracking.startFirebasePerformanceTracking(keyText: Constants.Firebase.track4imageString, size: imageSizeString)
        FirebaseTracking.startFirebasePerformanceTracking(keyText: Constants.Firebase.track1imageString, size: imageSizeString)
        
        let resource = ImageResource(downloadURL:element)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { [weak self] result in
            switch result {
            case .success(let value):
                self?.images.append(value.image)
                self?.stopFirebaseTracking(keyName: Constants.Firebase.track1imageString)
                if ((self?.hasDownloaded4MorePictures(currentSize: currentSize)) != nil) {
                    completionHandler(.success(self!.images))
                    self?.stopFirebaseTracking(keyName: Constants.Firebase.track4imageString)
                    ViewController.hasStartedTracing4images = false
                    if((self?.images.count ?? 0) % 4 == 0) {
                        self?.shouldDownload = false
                    }
                    return
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }

    }
    
    func hasDownloaded4MorePictures(currentSize: Int) -> Bool {
        return self.images.count == currentSize+4
    }
        
    func startFirebaseTracking(keyName: String, imageSizeName: String) {
        FirebaseTracking.startFirebasePerformanceTracking(keyText: keyName, size: imageSizeName)
    }
    
    func stopFirebaseTracking(keyName: String) {
        FirebaseTracking.stopFirebaseTracking(keyName: keyName)
    }
    
}
