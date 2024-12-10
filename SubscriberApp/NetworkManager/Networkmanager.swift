//
//  Networkmanager.swift
//  SubscriberApp
//
//  Created by Muralidhar reddy Kakanuru on 12/9/24.
//

import Foundation
import UIKit

protocol SubscriberPro {
    func getData<T: Decodable>(url: String, completion: @escaping @Sendable (T?) -> ())
    func getImage(url: String, completion: @escaping (UIImage?) -> ())
}

class SubscribeNetwork: SubscriberPro{
    static let subInstance = SubscribeNetwork()
    private let urlSession: URLSession
    private var imageCache = NSCache<NSString, UIImage>()
    
    private init(){
        let config = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: config)
    }
    
    func getData<T: Decodable>(url: String, completion: @escaping @Sendable (T?) -> ()){
        guard let serverUrl = URL(string: url) else{
            print("invalid url")
            return
        }
        
        urlSession.dataTask(with: serverUrl){data, _, error in
            if let error = error {
                print("error occured")
                return
            }
            guard let data = data else{
                print("data is not availbale")
                return
            }
            do{
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(decoded)
            }
            catch{
                print("data is not decoded")
                
            }
        }.resume()
        
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()){
        if let cacheImage = imageCache.object(forKey: url as NSString){
            completion(cacheImage)
        }
        guard let serverURL = URL(string: url) else{
            print("Invalid URl")
            return
        }
        urlSession.dataTask(with: serverURL){data, _, error in
            if let error = error {
                print("invalid url")
                return
            }
            guard let data = data, let image = UIImage(data: data) else{
                print("no data and images available")
                return
            }
            self.imageCache.setObject(image, forKey: serverURL.absoluteString as NSString)
            completion(image)
        }.resume()
    }
}
    

