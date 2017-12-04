//
//  CategorySelectionViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 02.12.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class CategorySelectionViewController: UITableViewController {
    
    var categoryList: CategoryList!
    var categoriesFetcher: DataFetcher!
    static var selectedCategory: [String:String] = ["name":"Tech", "slug":"tech"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        categoriesFetcher.fetch(method: .categories, url: ProductHunterAPI.getCategories) { (fetchingResult) -> Void in
            switch fetchingResult {
            case let .success(categories):
                self.categoryList.categories = categories as! [Category]
                DispatchQueue.main.async {
                    self.categoryList.categories.sort(by: {$0.name < $1.name})
                    self.tableView.reloadData()
                }
                //print("Successfully found \(categories.count) categories.")
            case let .failure(error):
                print("Error fetching categories: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoryList.categories[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "category")
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryList.categories[indexPath.row]
        CategorySelectionViewController.selectedCategory = ["name": category.name, "slug": category.slug]
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPosts"?:
            if (tableView.indexPathForSelectedRow?.row) != nil {
                print("Go to posts list...")
                let vc = segue.destination as! PostsViewController
                vc.postStore = PostStore()
                vc.postFetcher = DataFetcher()
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
