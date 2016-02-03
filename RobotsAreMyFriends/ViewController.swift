//
//  ViewController.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-02.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textfield: UITextField?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var collectionView: UICollectionView?
    
    var robotImages: [RobotImageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func findMyBotImage() {
        print("initiate fetch")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = RobotCollectionViewCell()
        cell.setupWithRobotImageModel(robotImages[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return robotImages.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("you've touched me")
    }
}
