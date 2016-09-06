//
//  RobotImageModel.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-02.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit
import AdvancedOperations

var robotFetchCounter = 0
let robotMax = 12

class RobotImageStore: NSObject {
    static let sharedStore = RobotImageStore()
    
    var robotImages: [RobotImageModel] = []
    
    func setNewImageForRobotName(robotName: String, newRobotImage: UIImage) {
        let numRobots = robotImages.count - 1
        for index in ((0...numRobots).reverse()) {
            let robotImageModel = robotImages[index]
            if robotImageModel.robotName == robotName {
                robotImageModel.robotImage = newRobotImage
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadAllCellsNotification, object: robotImageModel.robotName)
                return
            }
        }
    }
}

class RobotImageModel: NSObject {
    
    let robotName: String
    var robotImage: UIImage?
    
    init(name: String) {
        robotName = name
        super.init()
        
        let getMyRobotGroupOperation = GetMyRobotGroupOperation(robotName: robotName)
        
        /* // USE THIS ONE WITH MAX CONCURRENT = 1
        let qosInterval = robotMax / 5
        switch robotFetchCounter % robotMax {
        case 0..<qosInterval:
            NSLog("priority: very low")
            getMyRobotGroupOperation.queuePriority = .VeryLow
        case qosInterval..<(2*qosInterval):
            NSLog("priority: low")
            getMyRobotGroupOperation.queuePriority = .Low
        case (2*qosInterval)..<(3*qosInterval):
            NSLog("priority: normal")
            getMyRobotGroupOperation.queuePriority = .Normal
        case (3*qosInterval)..<(4*qosInterval):
            NSLog("priority: high")
            getMyRobotGroupOperation.queuePriority = .High
        default:
            NSLog("priority: very high")
            getMyRobotGroupOperation.queuePriority = .VeryHigh
        }*/
        
        /*
        let qosInterval = robotMax / 5
        switch robotFetchCounter % robotMax {
        case 0..<qosInterval:
            NSLog("qos = default")
            getMyRobotGroupOperation.qualityOfService = .Default
        case qosInterval..<(2*qosInterval):
            NSLog("qos = background")
            getMyRobotGroupOperation.qualityOfService = .Background
        case (2*qosInterval)..<(3*qosInterval):
            NSLog("qos = utility")
            getMyRobotGroupOperation.qualityOfService = .Utility
        case (3*qosInterval)..<(4*qosInterval):
            NSLog("qos = user initiated")
            getMyRobotGroupOperation.qualityOfService = .UserInitiated
        default:
            NSLog("qos = user interactive")
            getMyRobotGroupOperation.qualityOfService = .UserInteractive
        }*/
        
        RobotOperationQueue.addOperation(getMyRobotGroupOperation)
        
        robotFetchCounter += 1
    }
    
}
