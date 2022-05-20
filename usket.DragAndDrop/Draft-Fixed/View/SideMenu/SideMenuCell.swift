//
//  SideMenuCell.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/03.
//

import UIKit

final class SideMenuTableViewCell: UITableViewCell {
    
    static let identifier = "SideMenuTableViewCell"
    static var currentModuleType : ModuleType = .buttonModule
    let moduleImageView = UIImageView()
    var module: Module?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(moduleImageView)
        
        moduleImageView.contentMode = .scaleAspectFit
        
        moduleImageView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialModule(moduleType: ModuleType){
        self.moduleImageView.image = UIImage(named: moduleType.imageName)
    }
}
extension SideMenuTableViewCell: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        print(#function)
        if let dragItem = module?.dragItem {
            guard let module = module else {
                return []
            }
            // 현재 드래깅중인 모듈 타입
            SideMenuTableViewCell.currentModuleType = module.type
            
            return [dragItem]
        }
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        print(#function)
        
        guard let module = module else { return nil }
        
        let frontImage = UIImage(named: module.type.rawValue)
        let imageView = UIImageView(image: frontImage)
        imageView.contentMode = .scaleAspectFit
        
        //For shadow
        SideMenu.sizeOfItem = module.type.size
        
        let target = UIPreviewTarget(container: self , center: session.location(in: self))
        let parameters = UIPreviewParameters()
        let preview = UITargetedDragPreview(view: imageView, parameters: parameters, target: target)
        
        return preview
    }
}
