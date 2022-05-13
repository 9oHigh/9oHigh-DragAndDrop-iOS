//
//  DynamicSize.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/12.
//

import UIKit

final class DynamicGrid {

    static let shared = DynamicGrid()
    let col: Int = 30
    let row: Int = 12
    var width: Double = UIScreen().width * 0.8
    var height: Double = UIScreen().width * 0.8 * 0.386363

    func getRatio() -> [Double] {
        return [width / Double(col),height / Double(row)]
    }
}
