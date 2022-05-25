//
//  ButtonModuleViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/10.
//

import UIKit

final class ButtonModuleViewContoller: ModuleViewController {
    
    let button = UIButton()
    
    override init(module: Module) {
        super.init(module: module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: viewModel.module.type.rawValue), for: .normal)
        
        button.imageView?.snp.makeConstraints({ make in
            make.width.equalTo(viewModel.module.type.size.width)
            make.height.equalTo(viewModel.module.type.size.height)
        })
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(viewModel.module.type.size.width)
            make.height.equalTo(viewModel.module.type.size.height)
        }
    }
}
