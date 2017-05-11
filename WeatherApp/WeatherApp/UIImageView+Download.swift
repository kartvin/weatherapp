//
//  UIImageView+Download.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension UIImageView  {
    private func startDownload(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping (Data)->Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                completion(data)
                self.image = image
            }
            }.resume()
    }
    public func downloadImage(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping (Data,String)->Void) {
        guard let url = URL(string: link) else { return }
        startDownload(url: url, contentMode: mode) { (imgdate) in
            completion(imgdate, link)
        }
    }
}
