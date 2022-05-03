//
//  SideMenu.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/27.
//

import UIKit
import SnapKit

final class SideMenu: UIView {
    
    static var kindOfModule = ""
    static var sizeOfItem = ModuleSize(0, 0)
    var tableView = UITableView()
    // 임시
    var moduleList = [CustomModule(type: .button), CustomModule(type: .dial), CustomModule(type: .send), CustomModule(type: .timer)]
    
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
        addSubview(tableView)
    }
    
    private func setConfig(){
        
        backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        
        //Drag And Drop
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableView.backgroundColor = .lightGray
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 0)
    }
    
    private func setConstraints(){
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension SideMenu: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as? SideMenuTableViewCell else {
            return UITableViewCell()
        }
        
        cell.initialModule(moduleType: moduleList[indexPath.row].type)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
extension SideMenu: UITableViewDragDelegate,UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print(#function)
        let module = moduleList[indexPath.row]
        
        switch module.type {
            
        case .button:
            SideMenu.kindOfModule = "ButtonModule"
            SideMenu.sizeOfItem = ModuleSize(128, 128)
        case .send:
            SideMenu.kindOfModule = "SendModule"
            SideMenu.sizeOfItem = ModuleSize(272, 176)
        case .dial:
            SideMenu.kindOfModule = "DialModule"
            SideMenu.sizeOfItem = ModuleSize(128, 128)
        case .timer:
            SideMenu.kindOfModule = "TimerModule"
            SideMenu.sizeOfItem = ModuleSize(128,224)
        }
        
        let provider = NSItemProvider(object: module)
        let dragItem = UIDragItem(itemProvider: provider)
        
        dragItem.previewProvider = {
            let preview = UIImageView(image: UIImage(named: "\(SideMenu.kindOfModule).png"))
            return UIDragPreview(view: preview)
        }
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: CustomModule.self)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print(#function)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        print(#function)
        return UITableViewDropProposal(operation: .cancel)
    }
}
