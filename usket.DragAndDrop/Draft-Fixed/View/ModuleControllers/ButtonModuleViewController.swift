//
//  ButtonModuleViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/10.
//

import UIKit

final class ButtonModuleViewContoller: ModuleViewController {
    
    let button = UIButton()
    
    override init(module: Module, size: ModuleSize) {
        super.init(module: module, size: size)
        print("BUTTON:",size)
        print(view.frame.size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: module.type.rawValue), for: .normal)
        button.imageView?.snp.makeConstraints({ make in
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        })
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
    }
}
