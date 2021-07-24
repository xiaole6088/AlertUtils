//
//  UIWindow+TopViewController.swift
//  AlertUtils
//
//  Created by xiaole on 2021/7/24.
//

import Foundation
import UIKit

extension UIWindow {

    static func getkeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .last?.windows
            .filter({ $0.isKeyWindow })
            .last
    }
    
    static func topViewController() -> UIViewController? {
        guard let keyWindow = getkeyWindow() else {
            return nil
        }
        guard let rootVC = keyWindow.rootViewController else {
            return nil
        }
        let top = findoutTopViewController(vc: rootVC)
        return top
    }
    
    static func topAlert() -> UIAlertController? {
        guard let keyWindow = getkeyWindow() else {
            return nil
        }
        guard let rootVC = keyWindow.rootViewController else {
            return nil
        }
        return findoutTopAlert(vc: rootVC)
    }
    
    static func closeAlert(com: (() -> Void)?) {
        if let alert = topAlert() {
            alert.dismiss(animated: false, completion: com)
        }
    }
    
    private static func findoutTopAlert(vc: UIViewController) -> UIAlertController? {
        if let presentedVC = vc.presentedViewController {
            return findoutTopAlert(vc: presentedVC)
        }
        if vc.isKind(of: UIAlertController.classForCoder()) {
            return vc as? UIAlertController
        }
        return nil
    }
    
    private static func findoutTopViewController(vc: UIViewController) -> UIViewController {
        if let presentedVC = vc.presentedViewController, !presentedVC.isKind(of: UIAlertController.classForCoder()) {
            return findoutTopViewController(vc: presentedVC)
        }
        return vc
    }
}
