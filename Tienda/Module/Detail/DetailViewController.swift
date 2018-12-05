//
//  DetailViewController.swift
//  Tienda
//
//  Created by Ali Lopez Galaviz on 04/12/18.
//  Copyright © 2018 Ali López Galaviz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    
    var image : UIImage? {
        didSet{
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func updateUI() {
        if let imageView = self.imageView {
            imageView.image = image
        }
    }
    
}
