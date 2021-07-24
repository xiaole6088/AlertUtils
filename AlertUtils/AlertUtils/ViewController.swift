//
//  ViewController.swift
//  AlertUtils
//
//  Created by xiaole on 2021/7/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AlertUtils.shared.show(level: 1, title: "1", message: "level1", cancelStr: "取消", cancel: nil, okStr: "OK", ok: nil)
        AlertUtils.shared.show(level: 2, title: "2", message: "level2", cancelStr: "取消", cancel: nil, okStr: "OK", ok: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AlertUtils.shared.show(level: 3, title: "3", message: "3", cancelStr: "取消", cancel: nil, okStr: "OK", ok: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            AlertUtils.shared.show(level: 4, title: "4", message: "4", cancelStr: "取消", cancel: nil, okStr: "OK", ok: nil)
        }
    }


}

