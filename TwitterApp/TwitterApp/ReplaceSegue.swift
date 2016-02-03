//
//  File.swift
//  TwitterApp
//
//  Created by RWuser on 03/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class ReplaceSegue: UIStoryboardSegue{
    override func perform() {
        let sourceviewController = self.sourceViewController
        let destinationViewController = self.destinationViewController
        let navigationController = sourceviewController.navigationController
        
        var controllerStack = navigationController!.viewControllers
        controllerStack[controllerStack.indexOf(sourceviewController)!] = destinationViewController
        navigationController?.setViewControllers(controllerStack, animated: false)
    }

}
