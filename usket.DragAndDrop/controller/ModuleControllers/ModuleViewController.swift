//
//  ModuleViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/10.
//

import UIKit
import MobileCoreServices

class ModuleViewController: UIViewController {
    
    var module : Module
    var size: ModuleSize
    
    init(module: Module, size: ModuleSize) {
        self.module = module
        self.size = size
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addInteraction(UIDragInteraction(delegate: self))
    }
}
extension ModuleViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        print(#function)
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: module))
        
        switch module.type {
        case .buttonModule:
            SideMenu.sizeOfItem = ModuleSize(128, 128)
        case .sendModule:
            SideMenu.sizeOfItem = ModuleSize(272, 176)
        case .dialModule:
            SideMenu.sizeOfItem = ModuleSize(128, 128)
        case .timerModule:
            SideMenu.sizeOfItem = ModuleSize(128,224)
        }
        
        dragItem.localObject = self
        
        return [dragItem]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        print(#function)
        let target = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))
        
        let preview = UIImageView(image: UIImage(named: module.type.rawValue))
        
        return UITargetedDragPreview(view: preview, parameters:  UIDragPreviewParameters(),target: target)
    }
    
    // PerformDrop Success And Fail
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
        print(#function)
        
        if operation == .cancel {
            return
        }
        session.items.forEach { dragItem in
            if let draggedVC = dragItem.localObject as? ModuleViewController {
                CanvasView.clearPositon(draggedVC.view.frame)
                draggedVC.view.removeFromSuperview()
                draggedVC.removeFromParent()
            }
        }
    }
        
}
