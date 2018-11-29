//
//  WebServiceRequest.swift
//  contactListWIthSearchOptionCoreData
//
//  Created by Sds mac mini on 28/11/18.
//  Copyright © 2018 straightdrive.co.in. All rights reserved.
//

import Foundation
import UIKit

extension WebService{
    
    func countryDetails( block : @escaping WSCompletionBlock){
        let service = WebServiceToGetAllcountryList(manager : self, block : block)
        self.startRequest(service: service)
    }
}
