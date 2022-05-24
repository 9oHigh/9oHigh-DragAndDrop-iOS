//
//  ModuleViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/10.
//

import UIKit
import MobileCoreServices

class ModuleViewController: UIViewController {
    
    let viewModel: ModuleViewModel
    
    init(module: Module) {
        self.viewModel = ModuleViewModel(module: module)
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
        let dragItems = viewModel.itemsForBeginning()
        dragItems.first?.localObject = self
        return dragItems
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        print(#function)

        return viewModel.makePreviewForLifting(interaction: interaction, session: session)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
        print(#function)
        viewModel.setActionByOperation(session: session, operation: operation)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        print(#function)
        viewModel.sessionWillBegin()
    }
}
