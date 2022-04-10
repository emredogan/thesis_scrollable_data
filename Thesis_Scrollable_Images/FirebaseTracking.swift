//
//  FirebaseTracking.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 10/04/2022.
//

import Foundation
import FirebasePerformance

struct FirebaseTracking {
    static var trace4images: FirebasePerformance.Trace?
    static var trace1image: FirebasePerformance.Trace?
    static var cache: FirebasePerformance.Trace?
    
    @available(*, unavailable) private init() {}

    
    
    static func startFirebasePerformanceTracking(keyText: String, size: String?) {
        switch keyText {
        case Constants.Firebase.track1imageString:
            let firebaseText = keyText + " " + (size ?? "")
            FirebaseTracking.trace1image = Performance.startTrace(name: firebaseText)
            
        case Constants.Firebase.track4imageString:
            if(ViewController.hasStartedTracing4images == false) {
                let firebaseText = keyText + " " + (size ?? "")
                FirebaseTracking.trace4images = Performance.startTrace(name: firebaseText)
                ViewController.hasStartedTracing4images = true
            }
            
        case Constants.Firebase.cacheString:
            let firebaseText = keyText
            FirebaseTracking.cache = Performance.startTrace(name: firebaseText)
            
        default:
            print(Constants.Firebase.undefinedString)
        }
        
        func stopFirebaseTracking(trace: FirebasePerformance.Trace?) {
            trace?.stop()
        }
        
    }
    
    static func stopFirebaseTracking(keyName: String) {
        switch keyName {
        case Constants.Firebase.track1imageString:
            FirebaseTracking.trace1image?.stop()
        case Constants.Firebase.track4imageString:
            FirebaseTracking.trace4images?.stop()
            
        case Constants.Firebase.cacheString:
            FirebaseTracking.cache?.stop()
            
        default:
            print(Constants.Firebase.undefinedString)
        }
    }
}
