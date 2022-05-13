//
//  GridCollectionViewCell.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/13.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "GridCollectionViewCell"
    let point = CGPoint()
    var isFull: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
