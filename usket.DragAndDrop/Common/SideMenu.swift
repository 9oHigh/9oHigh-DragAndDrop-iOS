//
//  SideMenu.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/27.
//

import UIKit
import SnapKit

final class SideMenu: UIView {
    
    static var sizeOfItem = ModuleSize(0, 0)
    var tableView = UITableView()
    let viewModel = ViewModel()
    var moduleList = [Module(type: .buttonModule), Module(type: .dialModule), Module(type: .sendModule), Module(type: .timerModule)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConfig()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(tableView)
    }
    
    private func setConfig() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dropDelegate = self
        
        tableView.separatorStyle = .none
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
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
        
        let module = moduleList[indexPath.row]
        
        cell.initialModule(moduleType: moduleList[indexPath.row].type)
        cell.addInteraction(UIDragInteraction(delegate: cell))
        cell.module = module
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension SideMenu: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: Module.self)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
         print(#function)
        return UITableViewDropProposal(operation: .move)
    }
    
    
    
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        print(#function)
    }
}
