//
//  ProductsViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 27.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class  ProductsViewController: UITableViewController {
    
    var productStore: ProductStore!
    
    @IBAction func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("Refreshed")
        refreshControl.endRefreshing()
        //add launch of new request to PH
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.refreshControl(
        return productStore.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "product")!
        
        cell.textLabel?.text = productStore.products[indexPath.row].name
        cell.detailTextLabel?.text = productStore.products[indexPath.row].desc
        
        return cell
    }
}
