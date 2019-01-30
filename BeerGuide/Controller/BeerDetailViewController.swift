//
//  BeerDetailViewController.swift
//  AltSouceTest
//
//  Created by Robby King on 1/23/19.
//  Copyright © 2019 Robby King. All rights reserved.
//

import UIKit

class BeerDetailViewController: UIViewController {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var desc: String?
    var name: String?
    var tagline: String?
    
    
    override func viewDidLoad() {
        configureLabels()
        super.viewDidLoad()
    }
    
    func configureLabels() {
        guard let name = name, let tagline = tagline, let desc = desc  else {
            return
        }
        self.title = name
        
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.lineBreakMode = .byTruncatingTail
        descLabel.text = desc.last == "." ? desc : "\(desc)."
        descLabel.sizeToFit()
        
        nameLabel.text = name
        nameLabel.adjustsFontSizeToFitWidth = true
        
        taglineLabel.text = tagline
        taglineLabel.adjustsFontSizeToFitWidth = true
        
    }
}
