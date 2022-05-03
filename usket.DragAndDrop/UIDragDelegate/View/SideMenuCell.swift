//
//  SideMenuCell.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/03.
//

import UIKit

final class SideMenuTableViewCell: UITableViewCell {
    
    static let identifier = "SideMenuTableViewCell"
    let moduleImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(moduleImageView)
        
        moduleImageView.contentMode = .scaleAspectFill
        
        moduleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(40)
            make.trailing.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialModule(moduleType: CustomModuleType){
        
        self.moduleImageView.image = UIImage(named: moduleType.rawValue)
    }
}
