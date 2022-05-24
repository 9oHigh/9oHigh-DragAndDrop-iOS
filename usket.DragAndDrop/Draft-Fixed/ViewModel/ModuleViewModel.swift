//
//  ModuleViewModel.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/23.
//

import UIKit

final class ModuleViewModel {
    
    var module: Module
    
    init(module: Module){
        self.module = module
    }
    
    func itemsForBeginning() -> [UIDragItem]{
        if CanvasViewModel.status == .closed {
            return []
        }
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: module))
        
        Module.current = module.type.size
        
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
                    let frame = draggedVC.view.frame
                    let xPosition = Int(frame.minX / CanvasViewModel.rate)
                    let yPosition = Int(frame.minY / CanvasViewModel.rate)
                    self.setPosition((xPosition,yPosition), draggedVC.viewModel.module)
                }
            }
        case .forbidden:
            print("Forbidden")
        case .copy:
            print("Copy")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let frame = draggedVC.view.frame
                    let xPosition = Int(frame.minX)
                    let yPosition = Int(frame.minY)
                    self.setPosition(isClear: true,(xPosition,yPosition), draggedVC.viewModel.module)
                    draggedVC.view.removeFromSuperview()
                }
            }
        case .move:
            print("Move")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let frame = draggedVC.view.frame
                    let xPosition = Int(frame.minX)
                    let yPosition = Int(frame.minY)
                    self.setPosition(isClear: true,(xPosition,yPosition), draggedVC.viewModel.module)
                    
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
        let xPoint = Int(stPoint.x)
        let yPoint = Int(stPoint.y)
        self.setPosition(isClear: true,(xPoint,yPoint), module)
    }
    
    func setPosition(isClear: Bool = false,_ startPoint: (Int,Int),_ module: Module){
        
        let xPoint = startPoint.0
        let yPoint = startPoint.1
        
        let xEndPoint = Int(module.type.size.width / CanvasViewModel.rate)
        let yEndPoint = Int(module.type.size.height / CanvasViewModel.rate)
        
        for y in yPoint...yPoint + yEndPoint {
            for x in xPoint...xPoint + xEndPoint {
                if y >= 12 || x >= 30 {
                    return
                }
                CanvasViewModel.included[y][x] = !isClear
            }
        }
    }
}
    
