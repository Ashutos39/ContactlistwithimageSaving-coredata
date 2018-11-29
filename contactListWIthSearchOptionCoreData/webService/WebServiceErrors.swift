//
//  WebServiceErrors.swift
//  contactListWIthSearchOptionCoreData
//
//  Created by Sds mac mini on 28/11/18.
//  Copyright © 2018 straightdrive.co.in. All rights reserved.
//

import Foundation

//MARK: Network messages
struct NetworkMessage{
    
    static var kHTTPNoInternetMessage = "No Internet connection. Please check your internet connection."
    static var kHTTPTimeoutMessage = "Your network connection seems to be slow. Please check your network connection."
    static var  kHTTPUnknownErrorMessage = "Error in connection. Please check your internet connection and try again."
    static var  kHTTPHostNotFoundErrorMessage = "Cannot connect to server. Please try later."
    static var  kServerFailureMessage = "Cannot connect to server"
    
}

extension Error{
    
    public func title() -> String?{        
        return nil
    }
    
    public func message() -> String?{
        
        var message : String?
        
        let error = self as NSError
        let errormessage  = error.userInfo["message"] as? String
        let code = error.code
        
        switch code {
        case -1009:
            message = NetworkMessage.kHTTPNoInternetMessage
            break
            
        case -1001:
            message = NetworkMessage.kHTTPTimeoutMessage
            break
            
        case -1003:
            message = NetworkMessage.kHTTPHostNotFoundErrorMessage
            break
            
        case 500:
            message = NetworkMessage.kServerFailureMessage
            break
            
        default:
            message = NetworkMessage.kHTTPUnknownErrorMessage
            
            if errormessage != nil{
                message = errormessage
            }
        }
        
        return message
    }
    
}
