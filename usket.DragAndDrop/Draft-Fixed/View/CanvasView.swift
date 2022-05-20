//
//  CanvasView.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

final class CanvasView: UIViewController {
     
    // 가로 길이: 704, 세로 길이: 272
    static let columns = 30
    static let rows = 12
    static var included = [[Bool]](repeating: Array(repeating: false, count: columns),count: rows)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCanvas()
    }
    
    private func setCanvas(){
        
        let gridBackground = UIImageView(image: UIImage(named: "GridBackground.png"))
        gridBackground.contentMode = .scaleAspectFit
        
        view.addSubview(gridBackground)
        
        gridBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addChildVC(_ childVC : UIViewController,container: UIView) {
        addChild(childVC)
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        childVC.willMove(toParent: self)
        childVC.didMove(toParent: self)
    }
    
    func setLocation(_ startPoint: (Int,Int),_ module: Module) {
        
        var moduleVC = ModuleViewController(module: module, size: module.type.size)
        
        switch module.type {
            
        case .buttonModule:
            moduleVC = ButtonModuleViewContoller(module: module, size: module.type.size)
        case .sendModule:
            moduleVC = SendModuleViewContoller(module: module, size: module.type.size)
        case .dialModule:
            moduleVC = DialModuleViewContoller(module: module, size: module.type.size)
        case .timerModule:
            moduleVC = TimerModuleViewContoller(module: module, size: module.type.size)
        }
        
        addChildVC(moduleVC, container: view)
        
        moduleVC.view.frame = CGRect(x: CGFloat(startPoint.0) * CanvasViewController.rate, y: CGFloat(startPoint.1) * CanvasViewController.rate, width: module.type.size.width, height: module.type.size.height)
        print("RATE:",CanvasViewController.rate)
        print("SuperView:",moduleVC.view.superview?.findViewController()?.view.frame)
        print("Module:",moduleVC.view.frame)
        CanvasView.setPosition(startPoint, module)
    }
    
    func checkPosition(_ start: (Int,Int), width: Int, height: Int) -> Bool {
        for y in start.0...start.0 + Int(CGFloat(height)/CanvasViewController.rate){
            for x in start.1...start.1 + Int(CGFloat(width)/CanvasViewController.rate){
                //print("checkPosi:",y,x)
                if y >= 12 || x >= 30 { return false }
                else if y < 0 || x < 0 { return false }
                if CanvasView.included[y][x] {
                    return false
                }
            }
        }
        print("check OK")
        return true
    }
    
    static func setPosition(_ startPoint: (Int,Int),_ module: Module){
        // 자리 확보
        for y in startPoint.1...startPoint.1 + Int(module.type.size.height / CGFloat(CanvasViewController.rate)) {
            for x in startPoint.0 ... startPoint.0 + Int((module.type.size.width / CGFloat(CanvasViewController.rate)).rounded()) {
                if y >= 12 || x >= 30 {
                    return
                }
                CanvasView.included[y][x] = true
            }
        }
        
    }
    
    static func clearPositon(_ startPoint: (Int,Int),_ module: Module){
        
        for y in startPoint.1...startPoint.1 + Int(module.type.size.height / CanvasViewController.rate) {
            for x in startPoint.0 ... startPoint.0 + Int(module.type.size.width / CanvasViewController.rate) {
                if y >= 12 || x >= 30 {
                    return
                }
                CanvasView.included[y][x] = false
            }
        }
    }
}
