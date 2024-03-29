/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Contains the code related to automatic background tasks
*/

import UIKit

/**
    `BackgroundObserver` is an `OperationObserver` that will automatically begin
    and end a background task if the application transitions to the background.
    This would be useful if you had a vital `Operation` whose execution *must* complete,
    regardless of the activation state of the app. Some kinds network connections
    may fall in to this category, for example.
*/
public class BackgroundObserver: NSObject, OperationObserver {
    // MARK: Properties

    private var identifier = UIBackgroundTaskInvalid
    private var isInBackground = false
    
    public override init() {
        super.init()
        
        // We need to know when the application moves to/from the background.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BackgroundObserver.didEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BackgroundObserver.didEnterForeground(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        isInBackground = UIApplication.sharedApplication().applicationState == .Background
        
        // If we're in the background already, immediately begin the background task.
        if isInBackground {
            startBackgroundTask()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func didEnterBackground(notification: NSNotification) {
        if !isInBackground {
            isInBackground = true
            startBackgroundTask()
        }
    }
    
    @objc func didEnterForeground(notification: NSNotification) {
        if isInBackground {
            isInBackground = false
            endBackgroundTask()
        }
    }
    
    private func startBackgroundTask() {
        if identifier == UIBackgroundTaskInvalid {
            identifier = UIApplication.sharedApplication().beginBackgroundTaskWithName("BackgroundObserver", expirationHandler: {
                self.endBackgroundTask()
            })
        }
    }
    
    private func endBackgroundTask() {
        if identifier != UIBackgroundTaskInvalid {
            UIApplication.sharedApplication().endBackgroundTask(identifier)
            identifier = UIBackgroundTaskInvalid
        }
    }
    
    // MARK: Operation Observer
    
    public func operationDidStart(operation: Operation) { }
    
    public func operation(operation: Operation, didProduceOperation newOperation: NSOperation) { }

    public func operationDidFinish(operation: Operation, errors: [NSError]) {
        endBackgroundTask()
    }
}
