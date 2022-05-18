//
//  UIViewController + Extenstion.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/18.
//

import UIKit

extension UIViewController {
    
  func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
