//
//  GridCollectionViewCell.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/13.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "GridCollectionViewCell"
    var point = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPoint(_ point: CGPoint){
        self.point = point
    }
    
    func setShadow(_ color: UIColor){
        self.backgroundColor = color
    }
    
    func setShadow(width: Int, height: Int){
        
        let pointX = Int(self.point.x)
        let pointY = Int(self.point.y)
        
        for h in pointY...pointY + height - 1 {
            for w in pointX...pointX + width - 1 {
                if h > 10 || w > 28 {
                    return
                }
                if h < 0 || w < 0 {
                    return
                }
                Helper.gridArray[w][h] = true
            }
        }
    }
    
    func resetShadow(){
        self.backgroundColor = UIColor.clear
    }

    func droppedModule(width: Int, height: Int){
        
        let pointX = Int(self.point.x)
        let pointY = Int(self.point.y)
        
        for h in pointY...pointY + height - 1 {
            for w in pointX...pointX + width - 1 {
                if h > 10 || w > 28 {
                    return
                }
                if h < 0 || w < 0 {
                    return
                }
                Helper.droppedArray[w][h] = true
            }
        }
    }
}
extension GridCollectionViewCell: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: Module.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        /*
         let size = SideMenuTableViewCell.currentModuleType.size
         setShadow(width: size.col,height: size.row)
         Helper.reloadData()
         */
        
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
        session.loadObjects(ofClass: Module.self) { item in
            
            guard let customModule = item.first as? Module else {
                return
            }
            
            DispatchQueue.main.async {
                self.droppedModule(width: customModule.type.size.col , height: customModule.type.size.row)
                /*
                 let moduleVC = ModuleViewController(module: customModule, size: customModule.type.size)
                 
                 moduleVC.view = UIImageView(image: UIImage(named: customModule.type.rawValue))
                 
                 if let myViews = self.superview {
                     if let vc = myViews.findViewController() as? GridLayoutViewController {

                         vc.addChildVC(moduleVC, container: vc.collectionView)
                         
                         moduleVC.view.frame = CGRect(x: Double(self.point.x) * Double(self.frame.width), y: Double(self.point.y) * Double(self.frame.height) , width: Double(self.frame.width) * Double(customModule.type.size.col), height: Double(self.frame.height) * Double(customModule.type.size.row))
                     }
                 }
                 */
                Helper.reloadData()
            }
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        print(#function)
    }
}
