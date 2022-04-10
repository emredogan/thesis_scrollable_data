//
//  ViewController.swift
//  Thesis_Scrollable_Images
//
//  Created by Emre Dogan on 12/02/2022.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var urlArray = [URL]()
    var images = [UIImage]()
    private var isPaginating = false
    var currentStartIndex = 0
    var currentEndIndex = 4
    static var hasStartedTracing4images = false
    
    var networkingClient = NetworkingClient(size: nil)
    
    var shouldDownload = true
    var imageSizeName  = "632kb"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.clearCache()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        makeANetworkCall(size: imageSizeName)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            imageSizeName = "632kb"
            break
        case 1 :
            imageSizeName = "1038kb"
            break
        case 2 :
            imageSizeName = "1450kb"
            break
        case 3 :
            imageSizeName = "1926kb"
            break
        case 4 :
            imageSizeName = "2470kb"
            break
        default:
            break
        }
        restartData()
    }
    
    func restartData() {
        Utilities.clearCache()
        urlArray = [URL]()
        images = [UIImage]()
        tableView.setContentOffset(.zero, animated: true)
        tableView.reloadData()
        isPaginating = false
        currentStartIndex = 0
        currentEndIndex = 4
        ViewController.hasStartedTracing4images = false
        makeANetworkCall(size: imageSizeName)
    }
    
    func shouldHideFooter() -> Bool {
        return images.count >= urlArray.count - 5
    }
    
    func hasDownloaded4MorePictures(currentSize: Int) -> Bool {
        return self.images.count == currentSize+4
    }
    
    func updateIndexesForTheNextDownload() {
        if(self.currentStartIndex + 4 <= self.urlArray.count-1) {
            self.currentStartIndex = self.currentStartIndex + 4
        }
        
        if(self.currentEndIndex + 4 > self.urlArray.count-1) {
            self.currentEndIndex = self.urlArray.count-1
            
        } else {
            self.currentEndIndex = self.currentEndIndex + 4
            
        }
    }
    
    func retrieveImage(element: URL, currentSize: Int) {
        firebaseTracking.startFirebasePerformanceTracking(keyText: "Downloading 4 images", size: imageSizeName)
        firebaseTracking.startFirebasePerformanceTracking(keyText: "Downloading 1 image", size: imageSizeName)
        activateSpinnerInTableView()
        let resource = ImageResource(downloadURL:element)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { [weak self] result in
            switch result {
            case .success(let value):
                self?.images.append(value.image)
                self?.stopFirebaseTracking(trace: self?.trace1image)
                self?.hideSpinnerInTableView()
                if ((self?.hasDownloaded4MorePictures(currentSize: currentSize)) != nil) {
                    self?.updateTableViewAndData()
                    self?.stopFirebaseTracking(trace: self?.trace4images)
                    ViewController.hasStartedTracing4images = false
                    if((self?.images.count ?? 0) % 4 == 0) {
                        self?.shouldDownload = false
                    }
                    return
                }
            case .failure(let error):
                print("Error: \(error)")
                self?.isPaginating = false
                self?.tableView.tableFooterView = nil
            }
        }
        
    }
    
    func updateTableViewAndData() {
        self.isPaginating = false
        self.tableView.reloadData()
        self.updateIndexesForTheNextDownload()
        self.tableView.tableFooterView = nil
        
    }
    
    func activateSpinnerInTableView() {
        isPaginating = true
        self.tableView.tableFooterView = createSpinnerFooter()
    }
    
    func hideSpinnerInTableView() {
        if self.shouldHideFooter(){
            self.tableView.tableFooterView = nil
        }
    }
    

    
    func startMultipleImageDownload() {
        let currentSize = self.images.count
        shouldDownload = true
        
        for (index, element) in urlArray.enumerated() {
            if(shouldDownload) {
                if(index >= currentStartIndex && index < currentEndIndex) {
                    retrieveImage(element: element, currentSize: currentSize)
                } else {
                    continue
                }
            }
        }
    }
    
    func makeANetworkCall(size: String) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        tableView.backgroundView = spinner
        networkingClient = NetworkingClient(size: size)
        networkingClient.execute { [weak self] result in
            
            switch result {
            case .success(let responsePosts):
                self?.urlArray = responsePosts
                self?.startMultipleImageDownload()
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
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photo_cell", for: indexPath) as! PostTableViewCell
        if(urlArray.count > 0) {
            cell.postImageView.image = images[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(isPaginating) {
            return
        }
        
        if(isPaginating == false) {
            if indexPath.row + 1 == images.count {
                startMultipleImageDownload()
            }
            
        }
    }
}

