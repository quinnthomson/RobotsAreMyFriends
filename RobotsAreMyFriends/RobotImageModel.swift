//
//  RobotImageModel.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-02.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit
import AdvancedOperations

class RobotImageModel: NSObject {
    
    let robotName:String
    
    init(name: String) {
        robotName = name
        super.init()
        
        RobotOperationQueue.addOperation(GetMyRobotGroupOperation(robotName: robotName))
    }
    
}
