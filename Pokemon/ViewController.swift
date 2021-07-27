//
//  ViewController.swift
//  Pokemon
//
//  Created by ABC on 21/07/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

var loader : UIView?

extension UIViewController {
    
    func showLoader(view : UIView) {
        let loaderView = UIView.init(frame: view.bounds)
        loaderView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = loaderView.center
        
        DispatchQueue.main.async {
            loaderView.addSubview(activityIndicator)
            view.addSubview(loaderView)
        }
        
        loader = loaderView
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            if loader != nil {
                loader!.removeFromSuperview()
                loader = nil
            }
        }
    }
}

