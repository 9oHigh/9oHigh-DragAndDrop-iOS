//
//  UIView + Extension.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/17.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
