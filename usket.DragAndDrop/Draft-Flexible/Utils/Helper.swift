//
//  Helper.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/16.
//

import UIKit

//MARK: - Need Removing Static ( Refactor )
final class Helper {
    
    static var gridArray: [[Bool]] = [[Bool]](repeating: Array(repeating: false, count: 11),count: 29)
    
    static var droppedArray: [[Bool]] = [[Bool]](repeating: Array(repeating: false, count: 11),count: 29)
    
    static let collectionView: UICollectionView = {
        let layout = GridCollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    static var xCounter: Int = 0
    static var yCounter: Int = 0
    
    static func reloadData(collectionView: UICollectionView = collectionView){
        print(#function)
        xCounter = 0
        yCounter = 0
        
        //MARK: - Reload Issue ( can not ensure x,y point )
        DispatchQueue.main.async {
            gridArray = [[Bool]](repeating: Array(repeating: false, count: 11),count: 29)
        }
        collectionView.reloadData()
    }
}
