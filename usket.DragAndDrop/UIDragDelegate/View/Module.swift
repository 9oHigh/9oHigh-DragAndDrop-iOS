//
//  Module.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

enum ModuleType {
    case button(CGRect)
    case dial(CGRect)
    case imu(CGRect)
    case info(CGRect)
    case joystick(CGRect)
    case send(CGRect)
    case slide(CGRect)
}

final class Module: UIView {
    
    var rect : CGRect?
    var moduleType = ModuleType.button(CGRect(x: 0, y: 0, width: 0, height: 0))
    var moduleImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initailModule(_ moduleType: ModuleType, image: UIImage){

        moduleImageView.image = image
        self.addSubview(moduleImageView)
        self.moduleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.moduleType = moduleType
        
        switch moduleType {
        case .button(let cGRect):
            self.rect = cGRect
        case .dial(let cGRect):
            self.rect = cGRect
        case .imu(let cGRect):
            self.rect = cGRect
        case .info(let cGRect):
            self.rect = cGRect
        case .joystick(let cGRect):
            self.rect = cGRect
        case .send(let cGRect):
            self.rect = cGRect
        case .slide(let cGRect):
            self.rect = cGRect
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
