//
//  Post.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//

import Foundation

struct Post: Decodable {
    let id: String?
    let urls: [String: String]?
    let description: String?
}
