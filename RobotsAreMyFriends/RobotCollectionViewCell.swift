//
//  RobotCollectionViewCell.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-02.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit

class RobotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView?
    var robotImageModel: RobotImageModel?
    
    func setupWithRobotImageModel(model: RobotImageModel) {
        if let robotImage = model.robotImage {
            self.imageView?.image = robotImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
}
