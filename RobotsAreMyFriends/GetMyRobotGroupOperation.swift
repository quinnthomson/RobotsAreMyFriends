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
    
    init(operations: [NSOperation] = [], robotName roboName: String) {
        robotName = roboName
        
        super.init(operations: [])
        name = "\(robotName): -1- Group Operation"
        
        let getRobotURLOperation = GetRobotURLOperation(robotName: robotName)
        getRobotURLOperation.addObserver(self)
        
        addOperation(getRobotURLOperation)
    }
}

extension GetMyRobotGroupOperation: OperationObserver {
    func operationDidStart(operation: Operation) {
        // Do nothing
    }
    
    func operation(operation: Operation, didProduceOperation newOperation: NSOperation) {
        if operation is GetRobotURLOperation, let imageOperation = newOperation as? GetRobotImageOperation {
            imageOperation.name = "\(robotName): -3- Image Operation"
            imageOperation.addObserver(self)
            addOperation(imageOperation)
        }
    }
    
    func operationDidFinish(operation: Operation, errors: [NSError]) {
        if let operation = operation as? GetRobotImageOperation, newImage = operation.image {
            RobotImageStore.sharedStore.setNewImageForRobotName(robotName, newRobotImage: newImage)
        }
    }
}

private class GetRobotURLOperation: Operation {
    
    var URLTask: NSURLSessionTask?
    let robotName: String
    var imageURL: String?
    
    override func cancel() {
        if let task = URLTask {
            task.cancel()
        }
        super.cancel()
    }
    
    init(robotName roboName: String) {
        robotName = roboName
        super.init()
        name = "\(robotName): -2- URL Operation"
    }
    
    private override func execute() {
        
        guard let robotName = robotName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) else {
            finish()
            return
        }
        
        let parameters = ["text": robotName]
        
        URLTask = RobotAPIClient.sharedClient.GET("", parameters: parameters, success: { [weak self] (dataTask, JSON) -> Void in
            print("success: \(JSON)")
            
            if let JSON = JSON as? [String: String], _self = self {
                _self.imageURL = JSON["imageUrl"]
                _self.produceImageOperation()
            }
            
            self?.finish()
            }, failure: { [weak self] (dataTask, error) -> Void in
                print(error)
                self?.finish()
        })
    }
    
    private func produceImageOperation() {
        if let imageURL = imageURL {
            let imageOperation = GetRobotImageOperation(imageURL: imageURL)
            produceOperation(imageOperation)
        }
    }
}

private class GetRobotImageOperation: Operation {
    
    let imageURL: String
    var image: UIImage?
    
    init(imageURL url: String) {
        imageURL = url
        super.init()
    }
    
    private override func execute() {
        guard let imageURL = NSURL(string: imageURL) else {
            finish()
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(imageURL) { [weak self] (data, response, error) in
            
            if let data = data {
                self?.image = UIImage(data: data)
            }
            
            self?.finish()
            
            }.resume()
    }
}
