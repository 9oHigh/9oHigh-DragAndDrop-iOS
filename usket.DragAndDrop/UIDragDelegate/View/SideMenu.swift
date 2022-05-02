//
//  SideMenu.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/27.
//

import UIKit
import SnapKit

final class SideMenu: UIView {
     
    let module = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConfig()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(){
       addSubview(module)
    }
    
    func setConfig(){
        backgroundColor = .lightGray
        module.isUserInteractionEnabled = true
        module.contentMode = .scaleAspectFit
        module.image = UIImage(named: "ButtonModule")
    }
    
    func setConstraints(){
        module.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.top.equalTo(30)
        }
    }
}


