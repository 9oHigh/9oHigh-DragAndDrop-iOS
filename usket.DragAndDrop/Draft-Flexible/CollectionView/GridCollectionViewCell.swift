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
    var isFull: Bool = false
    
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
    
}
extension GridCollectionViewCell: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: Module.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print(#function)
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        print(#function)
    }
}
