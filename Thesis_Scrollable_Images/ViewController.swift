//
//  ViewController.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let networkingClient: NetworkingClient = NetworkingClient()
        networkingClient.execute { result in
            
            switch result {
            case .success(let responsePosts):
                self.posts = responsePosts
                self.tableView.reloadData()
            case .failure(let error):
                print("ERROR - Getting data from the network client ", error)
            }
            
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photo_cell", for: indexPath) as! PostTableViewCell
        
        let url = posts[indexPath.row].urls!["raw"]
        let url2 = posts[indexPath.row].urls!["full"]
        
        let description = posts[indexPath.row].description
        
        cell.postLabel?.text = description
        cell.postImageView.setImage(imageUrl: url!)
        cell.secondImageView.setImage(imageUrl: url2!)
        
        return cell
    }
    
    
}

