//
//  CompactDiscTableViewCell.swift
//  Tienda
//
//  Created by Ali Lopez Galaviz on 04/12/18.
//  Copyright © 2018 Ali López Galaviz. All rights reserved.
//

import UIKit
import StoreKit

struct Color {
    static let blue = UIColor.blue
    static let red = UIColor.red
}

protocol ItemViewCellDelegate : class{
    func purchaseItem(at index:Int)
}

class ItemViewCell: UITableViewCell {

    weak var delegate : ItemViewCellDelegate?
    
    @IBOutlet weak var itemImageView : UIImageView!
    @IBOutlet weak var itemTitleLabel : UILabel!
    @IBOutlet weak var purchaseButton : UIButton!
    
    func updateUI(item : StoreItem) {
        self.itemImageView.image = UIImage(named: item.imageName!)
        self.itemTitleLabel.text = item.title!
        self.purchaseButton.backgroundColor = item.purchased ? Color.blue : Color.red
        let purchaseText = "Comprar"
        self.purchaseButton.setTitle(item.purchased ? "Ver producto" : purchaseText, for: .normal)
    }
    
    func getPriceLabel(product : SKProduct){
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        if let price = formatter.string(from: product.price) {
            self.purchaseButton.setTitle("Comprar por: \(price)", for: .normal)
        }
    }
    
    @IBAction func purchaseAction(sender : UIButton){
        self.delegate?.purchaseItem(at: sender.tag)
    }
    
    
    
    
}
