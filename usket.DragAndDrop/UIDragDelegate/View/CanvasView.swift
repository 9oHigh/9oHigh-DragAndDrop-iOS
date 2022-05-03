//
//  CanvasView.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

final class CanvasView: UIView {
    
    // 가로 길이: 704, 세로 길이: 272
    // Frame의 시작점을 기준으로 차지하고 있는지!
    static let columns = 30
    static let rows = 12
    
    // 해당 칸이 자리를 차지하고 있는지
    var included = [[Bool]](repeating: Array(repeating: false, count: columns),count: rows)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCanvas()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCanvas(){
        
        let gridBackground = UIImageView(image: UIImage(named: "GridBackground.png"))
        gridBackground.contentMode = .scaleAspectFit
    
        addSubview(gridBackground)
        
        gridBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setLocation(_ startPoint: (Int,Int),_ moduleType: CustomModuleType) {
        
        if included[startPoint.1][startPoint.0] {
            return
        } else {
            let module = Module(frame: .zero)
            
            switch moduleType {
            case .button:
                module.initailModule(moduleType, image: UIImage(named: "ButtonModule.png")!)
            case .dial:
                module.initailModule(moduleType, image: UIImage(named: "DialModule.png")!)
            case .send:
                module.initailModule(moduleType, image: UIImage(named: "SendModule.png")!)
            case .timer:
                module.initailModule(moduleType, image: UIImage(named: "TimerModule.png")!)
            }
            
            addSubview(module)
            module.frame = CGRect(x: Double(startPoint.0 * 24), y: Double(startPoint.1 * 24), width: module.size!.width, height: module.size!.height)
            //자리 차지
            for y in startPoint.1...startPoint.1 + Int(module.size!.height / 24) {
                if y >= 12 { return }
                for x in startPoint.0 ... startPoint.0 + Int(module.size!.width / 24) {
                    if x >= 30 {
                        included[y][x] = true
                        return
                    }
                    included[y][x] = true
                    print("INCLUDED",y,x,included[y][x])
                }
            }
        }
    }
    
    func checkPosition(_ start: (Int,Int), width: Int, height: Int) -> Bool {
        
        for y in start.0...start.0 + Int(height/24){
            if y >= 12 { return false }
            for x in start.1...start.1 + Int(width/24){
                if x >= 30 { return false }
                if included[y][x] {
                    return true
                }
            }
        }
        return false
    }
    
    //func findNewPosition(_ start: (Int,Int), width: Int, height: Int)-> CGPoint
    //func modifyLocation(){}
}
