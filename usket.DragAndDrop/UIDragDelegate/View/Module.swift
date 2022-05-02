//
//  Module.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

enum ModuleType {
    case button
    case dial
    case send
    case timer
}

final class Module: UIView {
    
    var moduleType = ModuleType.button
    // 해당 뷰를 덮을 뷰가 필요, 현재는 이미지뷰
    var moduleImageView = UIImageView()
    var size : ModuleSize?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initailModule(_ moduleType: ModuleType, image: UIImage){

        moduleImageView.image = image
        
        self.moduleType = moduleType
        setModuleType(self.moduleType)
        
        self.addSubview(moduleImageView)
        
        self.moduleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setModuleType(_ moduleType: ModuleType){
        
        switch moduleType {
        case .button:
            self.size = ModuleSize(128, 128)
        case .dial:
            self.size = ModuleSize(128, 128)
        case .send:
            self.size = ModuleSize(272, 176)
        case .timer:
            self.size = ModuleSize(128,224)
        }
    }
}
