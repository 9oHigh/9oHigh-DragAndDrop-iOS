//
//  CanvasView.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

final class CanvasView: UIView {
    
    // (56, 67) -> (700, 272)
    // 가로 길이: 644, 세로 길이: 205
    static let columns = 30
    static let rows = 12
    // 칸이 채워져 있는지 아닌지
    static var included = [[Bool]](repeating: Array(repeating: false, count: 30),count: 12)  // 30 * 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gridBackground = UIImageView(image: UIImage(named: "GridBackground.png"))
        gridBackground.contentMode = .scaleAspectFit
        
        addSubview(gridBackground)
        gridBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocations(_ xPosition: CGFloat,_ yPosition: CGFloat,_ module: Module){
        //각 모듈별로
        let properties = checkLocation(xPosition, yPosition, module)
        
        if properties.2 {
            addSubview(module)
            module.frame = CGRect(x: properties.0, y: properties.1, width: module.rect!.width, height: module.rect!.height)
            appendModule(rect: module.rect!)
        } else {
            // 제자리로 돌아가는 로직(To TableView)
        }
    }
    
    func checkLocation(_ xPosition: CGFloat,_ yPosition: CGFloat,_ module: Module) -> (CGFloat,CGFloat,Bool){
        let setX = xPosition - 56
        let setY = yPosition - 70
        //일단 트루
        return (setX,setY,true)
    }
    
    func appendModule(rect: CGRect){
        print("RECT",rect)
        let realX: Int = Int(rect.minX / 22)
        let realY: Int = Int(rect.minY / 17)
        
        for xPosition in realX...realX + Int(rect.width) {
            for yPosition in realY...realY + Int(rect.height) {
                print(realX,realY)
                CanvasView.included[xPosition][yPosition] = true
            }
        }
    }
}
