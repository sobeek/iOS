//
//  ProductsViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 27.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ProductsViewController: UITableViewController {
    
    var productStore: ProductStore!
    var productsFetcher: ProductsFetcher!
    
    @IBAction func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("Refreshed")
        loadData()
        refreshControl.endRefreshing()
        //add launch of new request to Producthunt
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.refreshControl(
        return productStore.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("Fill table...")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductCell
        //cell.thumbnail = UIImageView()
        
        let product = productStore.products[indexPath.row]
        
        cell.productTitle?.text = product.title
        cell.descriptionTitle?.text = product.desc
        
        let imageDownloader = ImageDownloader()
        imageDownloader.imageDownload(url: product.thumbnailURL, imageView: cell.thumbnail)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        loadData()
    }
    
    func loadData() {
        productsFetcher.fetchProducts() { (fetchingResult) -> Void in
            switch fetchingResult {
            case let .success(products):
                self.productStore.products = products
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Successfully found \(products.count) products.")
            case let .failure(error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showProductDetails"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let product = productStore.products[row]
                let detailViewController = segue.destination as! ProductDetailsViewController
                detailViewController.product = product
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
