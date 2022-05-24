//
//  ModuleViewModel.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/23.
//

import UIKit

final class ModuleViewModel {
    
    var module: Module
    var size: ModuleSize
    var label = UILabel()
    
    init(module: Module, size: ModuleSize){
        self.module = module
        self.size = size
    }
    
    func itemsForBeginning() -> [UIDragItem]{
        if CanvasViewModel.status == .closed {
            return []
        }
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: module))
        
        switch module.type {
        case .buttonModule:
            let width = UIScreen.main.bounds.width * 0.9
            let sizeCol = CGFloat(Int(128 * width / 704))
            let size = ModuleSize(sizeCol, sizeCol)
            SideMenu.sizeOfItem = size
        case .sendModule:
            let width = UIScreen.main.bounds.width * 0.9
            let sizeRow = CGFloat(Int(272 * width / 704))
            let sizeCol = CGFloat(Int(176 * width / 704))
            let size = ModuleSize(sizeRow, sizeCol)
            SideMenu.sizeOfItem = size
        case .dialModule:
            let width = UIScreen.main.bounds.width * 0.9
            let sizeCol = CGFloat(Int(128 * width / 704))
            let size = ModuleSize(sizeCol, sizeCol)
            SideMenu.sizeOfItem = size
        case .timerModule:
            let width = UIScreen.main.bounds.width * 0.9
            let sizeCol = CGFloat(Int(224 * width / 704))
            let sizeRow = CGFloat(Int(128 * width / 704))
            let size = ModuleSize(sizeRow,sizeCol)
            SideMenu.sizeOfItem = size
        }
        return [dragItem]
    }
    
    func makePreviewForLifting(interaction: UIDragInteraction,session: UIDragSession) -> UITargetedDragPreview?{
        
        let target = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))
        
        let preview = UIImageView(image: UIImage(named: module.type.rawValue))
        
        return UITargetedDragPreview(view: preview, parameters: UIDragPreviewParameters(), target: target)
    }
    
    func setActionByOperation(session: UIDragSession,operation: UIDropOperation){
        switch operation {
        case .cancel:
            print("Cancel")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let point = draggedVC.view.frame
                    CanvasViewModel.setPosition((Int(point.minX / CanvasViewModel.rate),Int(point.minY / CanvasViewModel.rate)), draggedVC.viewModel.module)
                }
            }
        case .forbidden:
            print("Forbidden")
        case .copy:
            print("Copy")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let point = draggedVC.view.frame
                    CanvasViewModel.clearPositon((Int(point.minX),Int(point.minY)), draggedVC.viewModel.module)
                    draggedVC.view.removeFromSuperview()
                }
            }
        case .move:
            print("move")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let point = draggedVC.view.frame
                    CanvasViewModel.clearPositon((Int(point.minX),Int(point.minY)), draggedVC.viewModel.module)
                    
                    let location = session.location(in: draggedVC.view.superview ?? UIView())
                    
                    UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut) {
                        
                        draggedVC.view.frame = CGRect(x: location.x , y: location.y, width: 100, height: 100)
                        draggedVC.view.layer.opacity = 0.0
                    } completion: { comp in
                        draggedVC.view.removeFromSuperview()
                    }
                    
                    if let superVC = draggedVC.view.superview?.superview?.findViewController() as? MainViewController{
                        superVC.viewModel.removeModule(module: draggedVC.viewModel.module, index: draggedVC.viewModel.module.index!)
                    }
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    func sessionWillBegin(){
        guard let stPoint = module.startPoint else {
            return
        }
        CanvasViewModel.clearPositon((Int(stPoint.x), Int(stPoint.y)),module)
    }
}
    
