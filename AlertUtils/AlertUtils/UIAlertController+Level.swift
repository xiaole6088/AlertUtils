//
//  UIAlertController+Level.swift
//  AlertUtils
//
//  Created by xiaole on 2021/7/24.
//

import Foundation
import UIKit

var alertLevelKey = "alertLevelKey"

extension UIAlertController {

    var level: Int {
        get {
            if let rs = objc_getAssociatedObject(self, &alertLevelKey) as? Int {
                return rs
            }
            return 999
        }
        set {
            objc_setAssociatedObject(self, &alertLevelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

}
