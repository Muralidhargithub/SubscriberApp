//
//  ViewController.swift
//  SubscriberApp
//
//  Created by Muralidhar reddy Kakanuru on 12/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = SubscriberController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.largeContentTitle = "Subscriber App"
    }
    func setUp(){
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }


}

