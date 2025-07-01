//
//  UIViewController+ext.swift
//  stop_tv
//
//  Created by Raissa Parente on 01/07/25.
//

import UIKit

extension UIViewController {
    func hideBackButtonIfAvailable() {
        #if !os(tvOS)
        self.navigationItem.hidesBackButton = true
        #endif
    }
}
