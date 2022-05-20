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
    var label = UILabel()
    
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
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.layer.zPosition = 10
        if module.index != nil {
            label.text = "\(String(describing: module.index! + 1))번"
            label.textColor = .red
            label.font = .boldSystemFont(ofSize: 20)
        }
    }
}
extension ModuleViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        print(#function)
        // 닫혀있으면 컨트롤 불가능
        if CanvasViewController.status == .closed {
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
        dragItem.localObject = self
        
        return [dragItem]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        print(#function)
        let target = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))
        
        let preview = UIImageView(image: UIImage(named: module.type.rawValue))
        
        return UITargetedDragPreview(view: preview, parameters:  UIDragPreviewParameters(),target: target)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
        print(#function)
        
        switch operation {
        case .cancel:
            print("Cancel")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let point = draggedVC.view.frame
                    CanvasView.setPosition((Int(point.minX / CanvasViewController.rate),Int(point.minY / CanvasViewController.rate)), draggedVC.module)
                }
            }
        case .forbidden:
            print("Forbidden")
        case .copy:
            print("Copy")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let point = draggedVC.view.frame
                    CanvasView.clearPositon((Int(point.minX),Int(point.minY)), draggedVC.module)
                    draggedVC.view.removeFromSuperview()
                }
            }
        case .move:
            print("move")
            session.items.forEach { dragItem in
                if let draggedVC = dragItem.localObject as? ModuleViewController {
                    let point = draggedVC.view.frame
                    CanvasView.clearPositon((Int(point.minX),Int(point.minY)), draggedVC.module)
                    
                    let location = session.location(in: draggedVC.view.superview ?? UIView())
                    
                    UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut) {
                        
                        draggedVC.view.frame = CGRect(x: location.x , y: location.y, width: 100, height: 100)
                        draggedVC.view.layer.opacity = 0.0
                    } completion: { comp in
                        draggedVC.view.removeFromSuperview()
                    }

                    if let superVC = draggedVC.view.superview?.superview?.findViewController() as? CanvasViewController{
                        superVC.viewModel.removeModule(module: draggedVC.module, index: draggedVC.module.index!)
                    }
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        print(#function)
        guard let stPoint = module.startPoint else {
            return
        }
        CanvasView.clearPositon((Int(stPoint.x),Int(stPoint.y)), module)
    }
}
