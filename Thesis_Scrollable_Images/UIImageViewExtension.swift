//
//  UIImageViewExtension.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imageUrl: String) {
        print("Setting image with KingFisher")
        self.kf.setImage(with:URL(string: imageUrl))
    }
}
