//
//  GetMyRobotGroupOperation.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-03.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit
import AdvancedOperations

let RobotOperationQueue = OperationQueue()

class GetMyRobotGroupOperation: GroupOperation {

    let robotName: String
    
    init(operations: [NSOperation] = [], robotName name: String) {
        robotName = name
        
        let getRobotURLOperation = GetRobotURLOperation(robotName: robotName)
        
        super.init(operations: [getRobotURLOperation])
    }
}

private class GetRobotURLOperation: Operation {
    
    var URLTask: NSURLSessionTask?
    let robotName: String
    
    override func cancel() {
        if let task = URLTask {
            task.cancel()
        }
        super.cancel()
    }
    
    init(robotName name: String) {
        robotName = name
        super.init()
    }
    
    private override func execute() {
        
        guard let robotName = robotName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) else {
            finish()
            return
        }
        
        let parameters = ["text": robotName]
        
        URLTask = RobotAPIClient.sharedClient.GET("", parameters: parameters, success: { (dataTask, JSON) -> Void in
            print("success: \(JSON)")
            }, failure: { (dataTask, error) -> Void in
                print(error)
        })
    }
    
}
