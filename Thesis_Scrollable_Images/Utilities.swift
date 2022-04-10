//
//  Utilities.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 10/04/2022.
//

import Foundation

struct Utilities {
    static func clearCache(){
        FirebaseTracking.startFirebasePerformanceTracking(keyText: Constants.Firebase.cacheString, size: nil)
        
        let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                do {
                    try fileManager.removeItem(at: file)
                }
                catch let error as NSError {
                    debugPrint("Ooops! Something went wrong: \(error)")
                }
                
            }
            FirebaseTracking.stopFirebaseTracking(keyName: Constants.Firebase.cacheString)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
