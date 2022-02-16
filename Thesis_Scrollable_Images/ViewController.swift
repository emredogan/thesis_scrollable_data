//
//  ViewController.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var urlArray = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let networkingClient: NetworkingClient = NetworkingClient()
        networkingClient.execute { result in
            
            switch result {
            case .success(let responsePosts):
                self.urlArray = responsePosts
                print("SIZE ", responsePosts.count)
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
        return urlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photo_cell", for: indexPath) as! PostTableViewCell
        if(urlArray.count > 0) {
            print("KING ", indexPath.row)
            cell.postImageView.setImage(imageUrl: urlArray[indexPath.row].absoluteString)
        }
        
        
        return cell
    }
    
    
}

