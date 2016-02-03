//
//  RobotImageModel.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-02.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit
import AdvancedOperations

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
        
        RobotOperationQueue.addOperation(GetMyRobotGroupOperation(robotName: robotName))
    }
    
}
