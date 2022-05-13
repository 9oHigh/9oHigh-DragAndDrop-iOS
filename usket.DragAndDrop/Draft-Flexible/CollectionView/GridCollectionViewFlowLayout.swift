//
//  GridCollectionViewFlowLayout.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/13.
//

import UIKit

final class GridCollectionViewFlowLayout: UICollectionViewFlowLayout{
    
    var columns: Int = 30
    let row: Int = 12

    init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0) {
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
  
        let itemWidth = ((collectionView.bounds.size.width) / CGFloat(columns))
        let itemHeight = ((collectionView.bounds.size.height) / CGFloat(row))
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}


