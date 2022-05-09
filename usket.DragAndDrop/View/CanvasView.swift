//
//  CanvasView.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

final class CanvasView: UIView {
    
    // 가로 길이: 704, 세로 길이: 272
    static let columns = 30
    static let rows = 12
    // 해당 칸이 자리를 차지하고 있는지
    static var included = [[Bool]](repeating: Array(repeating: false, count: columns),count: rows)
    
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
    
    func setLocation(_ startPoint: (Int,Int),_ moduleType: CustomModuleType,id: String) {
        
        let module = Module(frame: .zero)
        
        switch moduleType {
        case .button:
            module.initailModule(moduleType, id: id, image: UIImage(named: "ButtonModule.png")!)
        case .dial:
            module.initailModule(moduleType, id: id, image: UIImage(named: "DialModule.png")!)
        case .send:
            module.initailModule(moduleType, id: id, image: UIImage(named: "SendModule.png")!)
        case .timer:
            module.initailModule(moduleType, id: id, image: UIImage(named: "TimerModule.png")!)
        }
        
        addSubview(module)
        module.frame = CGRect(x: Double(startPoint.0 * 24), y: Double(startPoint.1 * 24), width: module.size!.width, height: module.size!.height)
        
        // 자리 확보
        for y in startPoint.1...startPoint.1 + Int(module.size!.height / 23.46) {
            for x in startPoint.0 ... startPoint.0 + Int(module.size!.width / 23.46) {
                if y >= 12 || x >= 30 {
                    return
                }
                CanvasView.included[y][x] = true
            }
        }
    }
    
    func checkPosition(_ start: (Int,Int), width: Int, height: Int) -> Bool {
        for y in start.0...start.0 + Int(height/24){
            for x in start.1...start.1 + Int(width/24){
                if y >= 12 || x >= 30 { return false }
                else if y < 0 || x < 0 { return false }
                if CanvasView.included[y][x] {
                    return false
                }
            }
        }
        return true
    }
    
    static func clearPositon(_ module: CGRect){
        
        let xPosition = Int(module.origin.x / 23.46)
        let yPosition = Int(module.origin.y / 23.46)
        
        for y in yPosition...yPosition + Int(module.height / 23.46) {
            for x in xPosition ... xPosition + Int(module.width / 23.46) {
                if y >= 12 || x >= 30 {
                    return
                }
                CanvasView.included[y][x] = false
            }
        }
    }
}
