//
//  AlertUtils.swift
//  AlertUtils
//
//  Created by xiaole on 2021/7/24.
//

import Foundation
import UIKit
typealias ClickBlock = (UIAlertAction) -> Void

class AlertUtils {
    
    static var shared: AlertUtils = AlertUtils()
    
    private weak var showingAlert: UIAlertController?
    private var waitingForShowAlerts: [UIAlertController] = []
    
    func show(level: Int,
              title: String?,
              message: String?,
              cancelStr: String?,
              cancel: ClickBlock?,
              okStr: String?,
              ok: ClickBlock?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let str = cancelStr, !str.isEmpty {
            let action = UIAlertAction(title: str, style: .cancel, handler: cancel)
            alert.addAction(action)
        }
        if let str = okStr, !str.isEmpty {
            let action = UIAlertAction(title: str, style: .default, handler: ok)
            alert.addAction(action)
        }
        alert.level = level
        prepareToShowAlert(alert: alert)
    }
    
    private func prepareToShowAlert(alert: UIAlertController) {
        // 如果新来的是高等级， 列队里面等待的低等级全部删除并不弹， 优先弹新来的最高级
        waitingForShowAlerts.removeAll { (value) -> Bool in
            return value.level < alert.level
        }
        // 如果进来的是比等待的级别还低的，或者同级， 则不弹新来的
        if let last = waitingForShowAlerts.last, alert.level <= last.level {
            return
        }
        // 讲新来的加入等待队列中
        waitingForShowAlerts.append(alert)
        // 检查队列并执行弹出
        checkAndShowAlert()
    }
    
    private func checkAndShowAlert() {
        guard let waitingFirst = waitingForShowAlerts.first else {
            return
        }
        if showingAlert == nil {
            // 没有正在present动画中的 alert, 队列里第一个可以进行弹出
            closeAndShow(new: waitingFirst)
        } else {
            // 当前有正在present过程中的alert, 必须等待系统弹出动画结束后才能处理
        }
    }
    
    private func closeAndShow(new: UIAlertController) {
        if let topAlert = UIWindow.topAlert() {
            // 当前画面有alert
            if topAlert.level < new.level {
                // 新来的alert是高级的， 先关闭低级的alert， 再弹高级的alert
                topAlert.dismiss(animated: false) { [weak self] in
                    self?.showAlert(new: new)
                }
            } else {
                // 新来的是同级或者低级的alert， 不弹alert
                return
            }
        } else {
            // 当前画面没有alert
            showAlert(new: new)
        }
    }
    
    private func showAlert(new: UIAlertController) {
        // 弹出alert, 执行present处理，带系统动画
        showingAlert = new
        // 从等待队列里删除第一个
        waitingForShowAlerts.removeFirst()
        DispatchQueue.main.async {
            UIWindow.topViewController()?.present(new, animated: true, completion: { [weak self] in
                // 动画结束， alert完全显示出来了
                self?.showingAlert = nil
                // 检查等待队列中是否有需要弹的alert
                self?.checkAndShowAlert()
            })
        }
        
    }
}
