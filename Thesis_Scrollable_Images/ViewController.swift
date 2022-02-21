//
//  ViewController.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentLimitCycleNumber = 10
    private var isPaginating = false
    
    var urlArray = [URL]()
    var limitedURlArray = [URL]()
    
    func makeANetworkCall() {
        let networkingClient: NetworkingClient = NetworkingClient()
        networkingClient.execute { result in
            
            switch result {
            case .success(let responsePosts):
                self.urlArray = responsePosts
                if(self.urlArray.count <= self.currentLimitCycleNumber) {
                    self.limitedURlArray = self.urlArray
                } else {
                    self.limitedURlArray = Array(self.urlArray[0 ..< self.currentLimitCycleNumber])
                }
                
                
                self.tableView.reloadData()

                
            case .failure(let error):
                print("ERROR - Getting data from the network client ", error)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // IGNORE THE SAFE AREA
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        makeANetworkCall()
    }
    
    func changeLimits() {
        if(self.urlArray.count <= self.currentLimitCycleNumber) {
            self.limitedURlArray = self.urlArray
        } else {
            self.limitedURlArray = Array(self.urlArray[0 ..< self.currentLimitCycleNumber])
        }

    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return limitedURlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photo_cell", for: indexPath) as! PostTableViewCell
        if(urlArray.count > 0) {
            cell.postImageView.setImage(imageUrl: urlArray[indexPath.row].absoluteString)
        }
        return cell
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 175))
        
        let spinner  = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if distanceFromBottom < height {
                print("fetch more you reached end of the table")
                isPaginating = true
                return
            } */
        if(isPaginating) {
            return
        }
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height-150-scrollView.contentOffset.y {
            if(isPaginating == false) {
                print("fetch more")
                self.tableView.tableFooterView = createSpinnerFooter()
                currentLimitCycleNumber = currentLimitCycleNumber + 4
                isPaginating = true
                changeLimits()

                
                // SOME TIME
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isPaginating = false
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()

                }
            }
            
        }
    }
    
    
}

