//
//  ButtonModuleViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/10.
//

import UIKit

final class TimerModuleViewContoller: ModuleViewController {
    
    let button = UIButton()
    
    override init(module: Module, size: ModuleSize) {
        super.init(module: module, size: size)
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
            make.width.equalTo(viewModel.size.width)
            make.height.equalTo(viewModel.size.height)
        })
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(viewModel.size.width)
            make.height.equalTo(viewModel.size.height)
        }
    }
}
