//
//  ViewController.swift
//  Tienda
//
//  Created by Ali Lopez Galaviz on 04/12/18.
//  Copyright © 2018 Ali López Galaviz. All rights reserved.
//

import UIKit
import StoreKit
//MARK: - MainViewController
class MainViewController: UIViewController {

    lazy var viewModel : MainViewModel = {
        return MainViewModel()
    }()
    
    var products = [SKProduct]()
    
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        let productRequest = SKProductsRequest(productIdentifiers: viewModel.getProductIdentifier())
        productRequest.delegate = self
        productRequest.start()
    }
    
    func initViewModel() {
        viewModel.reloadData = { [weak self] () in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func restorePurchaseAction(sender : Any) {
        //print("restore purchase")
        SKPaymentQueue.default().restoreCompletedTransactions()
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
        products.forEach { (product) in
            if product.productIdentifier == viewModel.getItem(at: indexPath).productIdentifier,
                !viewModel.getItem(at: indexPath).purchased{
                cell.getPriceLabel(product: product)
                cell.itemTitleLabel.text = product.localizedTitle
                cell.itemImageView.image = UIImage(named: viewModel.getItem(at: indexPath).imageName!)
            }
        }
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
        let product = viewModel.getItem(at: IndexPath(row: index, section: 0))
        if product.purchased == false {
            DispatchQueue.main.async {
                self.alert(message: "¿Estas seguro que deseas adquirir el producto?", completion: { (response) in
                    if response == .yes {
                        self.products.forEach({ (productFromApple) in
                            if product.productIdentifier! == productFromApple.productIdentifier {
                                SKPaymentQueue.default().add(self)
                                let payment = SKPayment(product: productFromApple)
                                SKPaymentQueue.default().add(payment)
                            }
                        })
                    }
                })
            }
            return
        }
        performSegue(withIdentifier: "detail_segue", sender: viewModel.getImage(at: IndexPath(row: index, section: 0)))
    }
    
}

extension MainViewController : SKProductsRequestDelegate{
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
}

extension MainViewController : SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                viewModel.unlockStoreItem(identifier: transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("restored")
                viewModel.unlockStoreItem(identifier: transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                print("deferred")
            }
        }
    }
    
}
