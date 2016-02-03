//
//  RobotAPIClient.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-02.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit
import AFNetworking

let robotBaseURLString = "https://robohash.p.mashape.com/index.php"
let headerKey = "X-Mashape-Key"
let headerValue = "2yR3yShI4Nmsh5AvxugiuOjKvt2Qp1rRtZSjsnzPjSsU0KCNGs"
let jsonHeaderKey = "Accept"
let jsonHeaderValue = "application/json"

class RobotAPIClient: AFHTTPSessionManager {
    static let sharedClient: RobotAPIClient = {
        let robotAPIClient = RobotAPIClient(baseURL: NSURL(string: robotBaseURLString))
        robotAPIClient.requestSerializer.setValue(headerValue, forHTTPHeaderField: headerKey)
        robotAPIClient.requestSerializer.setValue(jsonHeaderValue, forHTTPHeaderField: jsonHeaderKey)
        robotAPIClient.responseSerializer.acceptableContentTypes?.insert("text/html")
        return robotAPIClient
    }()
}
