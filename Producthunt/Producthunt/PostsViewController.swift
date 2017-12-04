//
//  PostsViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 27.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {
    
    var postStore: PostStore!
    var postFetcher: DataFetcher!
    var imageDownloader = ImageDownloader()
    
    @IBAction func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // there are postStore.posts.count cells for posts and another one cell for category selection
        return postStore.posts.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "topics")
            
            cell.detailTextLabel?.text = CategorySelectionViewController.selectedCategory["name"]
            cell.textLabel?.text = "Select topic"

            return cell

        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostCell
            
            let post = postStore.posts[indexPath.row - 1]
            
            cell.postTitle.text = post.title
            cell.descriptionTitle.text = post.desc
            cell.thumbnail.image = nil
            
//            cell.textLabel?.text = post.title
//            cell.detailTextLabel?.text = post.desc
//            cell.imageView?.image = nil
            
            imageDownloader.imageDownload(url: post.thumbnailURL, imageView: cell.thumbnail)
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        //self.navigationController?.
        self.navigationItem.title = CategorySelectionViewController.selectedCategory["name"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        postFetcher.fetch(method: .posts, url: ProductHunterAPI.getPosts) { (fetchingResult) -> Void in
            switch fetchingResult {
            case let .success(posts):
                self.postStore.posts = posts as! [Post]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "showCategoryList", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPostDetails"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let post = postStore.posts[row - 1]
                let detailViewController = segue.destination as! PostDetailsViewController
                detailViewController.post = post
            }
        case "showCategoryList"?:
            if (tableView.indexPathForSelectedRow?.row) != nil {
                let vc = segue.destination as! CategorySelectionViewController
                vc.categoriesFetcher = DataFetcher()
                vc.categoryList = CategoryList()
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
