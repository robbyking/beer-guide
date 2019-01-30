//
//  NetworkServices.swift
//  AltSouceTest
//
//  Created by Robby King on 1/22/19.
//  Copyright © 2019 Robby King. All rights reserved.
//

import Alamofire
import Foundation

class NetworkServices {
    
    func makeNetworkRequest(apiURL: String, completionHandler: @escaping (Data) -> Void) {
        Alamofire.request(apiURL).responseJSON { response in
            if let data = response.data {
                completionHandler(data)
            }
        }
    }
}
