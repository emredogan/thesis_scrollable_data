//
//  NetworkingClient.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//


import Foundation
import Alamofire

class NetworkingClient {
    let url = "https://api.unsplash.com/photos/?client_id=Bl6VoiuFBk4rEg-aRjLhyphcDrw_2Tve9lBxsvNo3A0"
    
    typealias CompletionHandler = ([Post]) -> Void
    
    func execute(completionHandler: @escaping CompletionHandler){
        var posts: [Post] = []
        AF.request(url).responseDecodable(of: [Post].self) { response in
            guard let responsePosts = response.value else {
                print("Error getting posts from the server")
                return }
            posts = responsePosts
            completionHandler(posts)
        }
    }
}
