//
//  UIImage.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 18/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadFrom(url: URL) {
        isHidden = true
        URLSession.shared.dataTask(with: url) { (data, response, taskError) in
            print("loaded")
            DispatchQueue.main.async {
                if let data = data {
                    self.image = UIImage(data: data)
                    self.isHidden = false
                }
            }
        }.resume()
    }
}
