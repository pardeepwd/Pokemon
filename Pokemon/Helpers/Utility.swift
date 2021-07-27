//
//  Utility.swift
//  Pokemon
//
//  Created by ABC on 21/07/21.
//

import UIKit
import Foundation

class Utility : NSObject {
    
    static let shared = Utility()
    private override init() { }
    
    let topController = UIApplication.topViewController()
    
    func showAlert(mesg: String) {
        displayAlert(title: "", message: mesg, control: ["Ok"])
    }
    
    //MARK:- Display alert without completion
    
    func displayAlert(title:String,message:String,control:[String]){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for str in control{
            
            let alertAction = UIAlertAction(title: str, style: .default, handler: { (action) in
            })
            
            alertController.addAction(alertAction)
        }
        topController?.present(alertController, animated: true, completion: nil)
    }
    
    func addrightBarButton(customXValue: CGFloat = 0, onVC: UIViewController, tapAction: Selector) -> UIView {
        let cartView = UIView(frame: CGRect(x: customXValue, y: 0, width: 24, height: 24))
        cartView.isUserInteractionEnabled = true
        
        let imgVw = UIImageView(frame: CGRect(x: 1, y: 0, width: 22, height: 22))
        imgVw.image = UIImage(named: "sort_ic")!
        //imgVw.tintColor = #colorLiteral(red: 1, green: 0.737254902, blue: 0, alpha: 1)
        imgVw.contentMode = .scaleAspectFit
       
        let tapRecognizer = UITapGestureRecognizer(target: onVC, action: tapAction)
        
        cartView.addSubview(imgVw)
        cartView.addGestureRecognizer(tapRecognizer)
        
        return cartView
    }
    
     func titleAttributes(textColor: UIColor) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-Medium", size: 18)!]
    }
    
    func showActionSheet(vc:UIViewController,title:String,message:String,completion: @escaping ((String) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "a-z", style: .default , handler:{ (UIAlertAction)in
            completion("alphabet")
        }))
        
        alert.addAction(UIAlertAction(title: "1-N", style: .default , handler:{ (UIAlertAction)in
            completion("number")
        }))
        
        alert.addAction(UIAlertAction(title: "Reset to default", style: .default , handler:{ (UIAlertAction)in
            completion("reset")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            alert.dismiss(animated: true, completion: nil)
        }))
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        vc.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
   
}

