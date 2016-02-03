//
//  ViewController.swift
//  RobotsAreMyFriends
//
//  Created by Quinn Thomson on 2016-02-02.
//  Copyright © 2016 Robots And Pencils. All rights reserved.
//

import UIKit

private let RobotCellReuseIdentifier = "RobotCell"
private let RobotFriends = ["Paul", "Sam", "Dave", "Mike", "Quinn", "Kate", "Bella", "Jude", "Asher", "Matt", "Ryan", "Jamie"]
let ReloadAllCellsNotification = "ReloadAllCellsNotification"

class ViewController: UIViewController {
    
    @IBOutlet var textfield: UITextField?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadCellFromNotification:"), name: ReloadAllCellsNotification, object: nil)
    }
    
    @IBAction func findMyBotImage() {
        if let newName = textfield?.text {
            let newModel = RobotImageModel(name: newName)
            RobotImageStore.sharedStore.robotImages.append(newModel)
        }
    }
    
    @IBAction func findMyBotFriends() {
        for newName in RobotFriends {
            let newModel = RobotImageModel(name: newName)
            RobotImageStore.sharedStore.robotImages.append(newModel)
        }
    }
    
    func reloadCellFromNotification(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.collectionView?.reloadData()
            let index = RobotImageStore.sharedStore.robotImages.count - 1
            self?.collectionView?.selectItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Bottom)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(RobotCellReuseIdentifier, forIndexPath: indexPath)
        if let cell = cell as? RobotCollectionViewCell {
            cell.setupWithRobotImageModel(RobotImageStore.sharedStore.robotImages[indexPath.row])
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RobotImageStore.sharedStore.robotImages.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let robotImage = RobotImageStore.sharedStore.robotImages[indexPath.row].robotImage {
            imageView?.image = robotImage
        }
    }
}
