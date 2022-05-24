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
    var module: Module?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(moduleImageView)
        
        separatorInset = UIEdgeInsets(top: 0, left: 500, bottom: 0, right: 0)
        
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

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    func setModule(moduleType: ModuleType){
        self.moduleImageView.image = UIImage(named: moduleType.imageName)
    }
}
extension SideMenuTableViewCell: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {

        if let dragItem = module?.dragItem {
            return [dragItem]
        }
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        
        guard let module = module else { return nil }
        
        let frontImage = UIImage(named: module.type.rawValue)
        let imageView = UIImageView(image: frontImage)
        imageView.contentMode = .scaleAspectFit
        
        let target = UIPreviewTarget(container: self , center: session.location(in: self))
        let parameters = UIPreviewParameters()
        
        //Shadow Size of current Module
        Module.current = module.type.size

        return  UITargetedDragPreview(view: imageView, parameters: parameters, target: target)
    }
}
