//
//  ViewController.swift
//  AltSouceTest
//
//  Created by Robby King on 1/22/19.
//  Copyright © 2019 Robby King. All rights reserved.
//

import UIKit

class BeerListViewController: UIViewController {
 
    @IBOutlet weak var beerListTableView: UITableView!
    let imageCache = NSCache<AnyObject, AnyObject>()
    var beerList = Beer() {
        didSet {
            self.beerListTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getBeerData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBeerDetailSegue" {
            guard let beerDetails = segue.destination as? BeerDetailViewController else {
                return
            }
            guard let row = beerListTableView.indexPathForSelectedRow?.row else {
                return
            }

            let beer = beerList[row]
            beerDetails.name = beer.name
            beerDetails.desc = beer.description
            beerDetails.tagline = beer.tagline
        }
    }
    
    func configureViewController() {
        self.title = "Beers"
    }
    
    func configureTableView() {
        beerListTableView.dataSource = self
        beerListTableView.delegate = self
        beerListTableView.register(UINib(nibName: "BeerListTableViewCell", bundle: nil), forCellReuseIdentifier: "BeerListTableViewCell")
    }
    
    func getBeerData() {
        let networkServices = NetworkServices()
        let apiURL = "https://api.punkapi.com/v2/beers"
        networkServices.makeNetworkRequest(apiURL: apiURL, completionHandler: { (response) in //Weakself?
            if let beer = try? JSONDecoder().decode(Beer.self, from: response) {
                self.beerList = beer.sorted(by: {$0.name < $1.name})
                self.setImageCache()
            }
        })
    }
    
    func setImageCache() {
        for index in 0..<beerList.count {
            imageCache.setObject(imageFromURLString(urlString: beerList[index].imageURL), forKey: index as AnyObject)
        }
    }
    
    func imageFromURLString(urlString: String) -> UIImage {
        guard let imageURL = URL(string: urlString), let data = try? Data(contentsOf: imageURL), let imageFromData = UIImage(data: data) else {
            return UIImage()
        }
        return imageFromData
    }
}

extension BeerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowBeerDetailSegue", sender: self)
    }
}

extension BeerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListTableViewCell", for: indexPath) as! BeerListTableViewCell
        if let thumbnailImage = imageCache.object(forKey: indexPath.row as AnyObject) as? UIImage {
            cell.thumbNailView.image = thumbnailImage
        }
        cell.titleLabel.text = beerList[indexPath.row].name
        return cell
    }
}
