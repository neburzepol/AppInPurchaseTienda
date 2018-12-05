//
//  UIViewController+Extension.swift
//  Tienda
//
//  Created by Ali Lopez Galaviz on 04/12/18.
//  Copyright © 2018 Ali López Galaviz. All rights reserved.
//

import Foundation
import UIKit

enum Answer {
    case yes
    case no
}

extension UIViewController {
    
    func alert(message:String, completion:@escaping (Answer)->()) {
        
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Si", style: .default) { (alert) in
            completion(.yes)
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (alert) in
            completion(.no)
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
