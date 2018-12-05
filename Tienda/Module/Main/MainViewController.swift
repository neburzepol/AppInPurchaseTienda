//
//  ViewController.swift
//  Tienda
//
//  Created by Ali Lopez Galaviz on 04/12/18.
//  Copyright © 2018 Ali López Galaviz. All rights reserved.
//

import UIKit
//MARK: - MainViewController
class MainViewController: UIViewController {

    lazy var viewModel : MainViewModel = {
        return MainViewModel()
    }()
    
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    func initViewModel() {
        viewModel.reloadData = { [weak self] () in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func restorePurchaseAction(sender : Any) {
        print("restore purchase")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.image = sender as? UIImage
        }
    }
    
}

//MARK: - UITableViewDataSource
extension MainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.getItem(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
            ItemViewCell else {
                return UITableViewCell()
        }
        cell.updateUI(item: item)
        cell.purchaseButton.tag = indexPath.row
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

//MARK: - ItemViewCellDelegate
extension MainViewController : ItemViewCellDelegate {
    
    func purchaseItem(at index: Int) {
        if viewModel.getItem(at: IndexPath(row: index, section: 0)).purchased == false {
            DispatchQueue.main.async {
                self.alert(message: "¿Estas seguro que deseas adquirir el producto?", completion: { (response) in
                    if response == .yes {
                        print("Proceso de compra")
                    }
                })
            }
            return
        }
        performSegue(withIdentifier: "detail_segue", sender: viewModel.getImage(at: IndexPath(row: index, section: 0)))
    }
    
}
