/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how to present an alert as part of an operation.
*/

import UIKit

public class AlertOperation: Operation {
    // MARK: Properties

    public let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
    public let presentationContext: UIViewController?
    public var completion: (() -> Void)?
    
    public var title: String? {
        get {
            return alertController.title
        }

        set {
            alertController.title = newValue
            name = newValue
        }
    }
    
    public var message: String? {
        get {
            return alertController.message
        }
        
        set {
            alertController.message = newValue
        }
    }
    
    // MARK: Initialization
    
    public init(presentationContext: UIViewController? = nil) {
        self.presentationContext = presentationContext ?? AlertOperation.topViewController() ?? UIApplication.sharedApplication().keyWindow?.rootViewController

        super.init()
        
        addCondition(AlertPresentation())
        
        /*
            This operation modifies the view controller hierarchy.
            Doing this while other such operations are executing can lead to
            inconsistencies in UIKit. So, let's make them mutally exclusive.
        */
        addCondition(MutuallyExclusive<UIViewController>())
    }
    
    public func addAction(title: String, style: UIAlertActionStyle = .Default, handler: AlertOperation -> Void = { _ in }) {
        let action = UIAlertAction(title: title, style: style) { [weak self] _ in
            if let strongSelf = self {
                handler(strongSelf)
            }

            self?.finish()
        }
        
        alertController.addAction(action)
    }
    
    public override func execute() {
        guard let presentationContext = presentationContext else {
            finish()

            return
        }

        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let _self = self {
                if _self.alertController.actions.isEmpty {
                    _self.addAction("OK")
                }
                
                presentationContext.presentViewController(_self.alertController, animated: true, completion: nil)
            }
        }
    }
    
    public override func finished(errors: [NSError]) {
        completion?()
    }
    
    private class func topViewController() -> UIViewController? {
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while topController?.presentedViewController != nil {
            if let newTopController = topController?.presentedViewController {
                topController = newTopController
            }
        }
        
        if let navController = topController?.navigationController {
            topController = navController.topViewController
        }
        
        return topController
    }
    
}
