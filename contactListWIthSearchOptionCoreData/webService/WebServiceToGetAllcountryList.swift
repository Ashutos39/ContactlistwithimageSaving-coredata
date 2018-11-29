//
//  WebServiceToGetAllcountryList.swift
//  contactListWIthSearchOptionCoreData
//
//  Created by Sds mac mini on 28/11/18.
//  Copyright © 2018 straightdrive.co.in. All rights reserved.
//

import Foundation
import Alamofire

class WebServiceToGetAllcountryList : WebServiceRequest{
    
    override init(manager : WebService, block : @escaping WSCompletionBlock) {
        
        super.init(manager : manager, block: block)
     
        url = manager.URL
        httpMethod = HTTPMethod.get
    }
    override func responseSuccess(data : Any?){
        
        if let response = data as? [String : Any]{
        }
        super.responseSuccess(data: data)
    }
    
    
}
