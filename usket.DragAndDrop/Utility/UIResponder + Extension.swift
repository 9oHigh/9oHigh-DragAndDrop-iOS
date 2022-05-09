//
//  UIResponder + Extension.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/04.
//

import UIKit

extension UIResponder {

    public var parentView: UIView? {
        return next as? UIView ?? next?.parentView
    }
}
