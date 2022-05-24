//
//  UIView + Extension.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/24.
//

import UIKit

extension UIView {
        
    func setShadow(){
        layer.shadowOpacity = 0.075
        layer.shadowOffset = CGSize(width: -8, height: 0)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    func unsetShadow(){
        layer.masksToBounds = true
    }
}
