//
//  WebService.swift
//  contactListWIthSearchOptionCoreData
//
//  Created by Sds mac mini on 28/11/18.
//  Copyright © 2018 straightdrive.co.in. All rights reserved.
//

import Foundation
enum BTApiEndPoints {
    
    
}

class WebService: NSObject {
    
    var serviceArray = [WebServiceRequest]()
    
    static let sharedService : WebService = {
        let instance = WebService()
        return instance
    }()

    var URL = "https://restcountries.eu/rest/v1/all"
    private override init() {
    }
    
    func startRequest(service : WebServiceRequest){
        service.start()
        serviceArray.append(service)
        print("services started = \(self.serviceArray.count)")
    }
    
    func stopRequest(service : WebServiceRequest){
        service.stop()
    }
    
    func closeService(service : WebServiceRequest?){
        guard service != nil else{
            return
        }
        if self.serviceArray.contains(service!) == true{
            self.serviceArray.remove(at: serviceArray.index(of: service!)!)
        }
        print("service pending = \(self.serviceArray.count)")
    }
    
    func cancelAllRequests(){
        
        for service in self.serviceArray {
            self.stopRequest(service: service)
        }
        print("service pending = \(self.serviceArray.count)")
        self.serviceArray.removeAll()
    }
}
