//
//  MainViewModel.swift
//  Tienda
//
//  Created by Ali Lopez Galaviz on 04/12/18.
//  Copyright © 2018 Ali López Galaviz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public typealias simpleClosure = (() -> ())?

public protocol MainProtocol : class{
    var reloadData : simpleClosure { get set }
}

class MainViewModel : MainProtocol{
    
    var reloadData: simpleClosure
    
    var storeCollection = [StoreItem]()
    
    init() {
        updateStore()
        if self.storeCollection.count == 0 {
            createItemStore(title: "Diseño de interfases", imageName: "design", purchased: true, productIdentifier: "")
            createItemStore(title: "Desarrollo apps", imageName: "development", purchased: false, productIdentifier: "com.artkode.tiendaali.apps")
            createItemStore(title: "Desarrollo de videojuegos", imageName: "videogames", purchased: false, productIdentifier: "com.artkode.tiendaali.videogames")
            createItemStore(title: "Matematicas", imageName: "maths", purchased: false, productIdentifier: "com.artkode.tiendaali.maths")
            createItemStore(title: "Kill em all", imageName: "kill", purchased: false, productIdentifier: "com.artkode.tiendaali.kill")
            createItemStore(title: "Ride the lightning", imageName: "ride", purchased: false, productIdentifier: "com.artkode.tiendaali.ride")
            createItemStore(title: "Master of puppets", imageName: "master", purchased: false, productIdentifier: "com.artkode.tiendaali.master")
            createItemStore(title: "... and justice for all", imageName: "justice", purchased: false, productIdentifier: "com.artkode.tiendaali.justice")
            updateStore()
            self.reloadData?()
        }
    }
    
    func createItemStore(title:String, imageName:String, purchased:Bool, productIdentifier:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenceContainer = appDelegate.persistentContainer
        let context = persistenceContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "StoreItem", in: context) {
            let item = NSManagedObject(entity: entity, insertInto: context) as! StoreItem
            item.title = title
            item.imageName = imageName
            item.purchased = purchased
            item.productIdentifier = productIdentifier
        }
        
        do {
            try context.save()
        }catch {}
        
    }
    
    func updateStore() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenceContainer = appDelegate.persistentContainer
        let context = persistenceContainer.viewContext
        
        let fetch : NSFetchRequest<StoreItem> = StoreItem.fetchRequest()
        
        do {
            self.storeCollection =  try context.fetch(fetch)
            self.reloadData?()
        } catch {
            print("trono como pistola")
        }
        
    }
    
    func numberOfItems()->Int{
        return storeCollection.count
    }
    
    func getItem(at indexPath:IndexPath) -> StoreItem {
        return storeCollection[indexPath.row]
    }
    
    func getImage(at indexPath:IndexPath) -> UIImage{
        return UIImage(named: self.storeCollection[indexPath.row].imageName!)!
    }
    
    func getProductIdentifier() -> Set<String>{
        var productsId = Set<String>()
        storeCollection.forEach { (storeItem) in
            productsId.insert(storeItem.productIdentifier!)
        }
        return productsId
    }
    
}
