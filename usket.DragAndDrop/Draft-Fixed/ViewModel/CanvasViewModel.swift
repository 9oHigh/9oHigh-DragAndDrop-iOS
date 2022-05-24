//
//  ViewModel.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/04.
//

import UIKit

enum MenuStatus {
    case open
    case closed
}

final class CanvasViewModel {
    
    static var status: MenuStatus = .open
    static var rate: CGFloat = 0
    // 가로 길이: 704, 세로 길이: 272
    static let columns = 30
    static let rows = 12
    static var included = [[Bool]](repeating: Array(repeating: false, count: columns),count: rows)
    var col: Int = 0
    var row: Int = 0
    
    var currentModuleDict: [ModuleType : [Module]] = [:]
    
    func addModule(module: Module) -> Bool{
        
        if currentModuleDict[module.type] == nil {
            currentModuleDict[module.type] = [module]
            module.index = 0
            return true
        } else {
            if module.type.max <= currentModuleDict[module.type]!.count {
                if module.index != nil {
                    return true
                }
                return false
            }
            currentModuleDict[module.type]!.append(module)
            module.index = findIndex(module: module)
            return true
        }
    }
    func findIndex(module: Module) -> Int {
        var flag : Int = 0
        for i in 0 ... module.type.max - 1 {
            flag = 0
            for item in currentModuleDict[module.type]! {
                if i == item.index {
                    flag += 1
                }
            }
            if flag == 0 {
                return i
            }
        }
        return 0
    }
    
    func removeModule(module: Module, index: Int){
        
        var posi : Int = 0
        for item in currentModuleDict[module.type]! {
            if item.index == index {
                currentModuleDict[module.type]?.remove(at: posi)
            }
            posi += 1
        }
    }
    
    func setLocation(_ startPoint: (Int,Int),_ module: Module, parentVC: UIViewController) {
        
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
        
        addChildVC(parentVC, moduleVC, container: parentVC.view)
        
        moduleVC.view.frame = CGRect(x: CGFloat(startPoint.0) * CanvasViewModel.rate, y: CGFloat(startPoint.1) * CanvasViewModel.rate, width: module.type.size.width, height: module.type.size.height)
        
        CanvasViewModel.setPosition(startPoint, module)
        print("CHILDREN",parentVC.children)
    }
    
    func checkPosition(_ start: (Int,Int), width: Int, height: Int) -> Bool {
        for y in start.0...start.0 + Int(CGFloat(height)/CanvasViewModel.rate){
            for x in start.1...start.1 + Int(CGFloat(width)/CanvasViewModel.rate){
                if y >= 12 || x >= 30 { return false }
                else if y < 0 || x < 0 { return false }
                if CanvasViewModel.included[y][x] {
                    return false
                }
            }
        }
        return true
    }
    
    static func setPosition(_ startPoint: (Int,Int),_ module: Module){
        // 자리 확보
        for y in startPoint.1...startPoint.1 + Int(module.type.size.height / CGFloat(CanvasViewModel.rate)) {
            for x in startPoint.0 ... startPoint.0 + Int((module.type.size.width / CGFloat(CanvasViewModel.rate)).rounded()) {
                if y >= 12 || x >= 30 {
                    return
                }
                CanvasViewModel.included[y][x] = true
            }
        }
        
    }
    
    static func clearPositon(_ startPoint: (Int,Int),_ module: Module){
        
        for y in startPoint.1...startPoint.1 + Int(module.type.size.height / CanvasViewModel.rate) {
            for x in startPoint.0 ... startPoint.0 + Int(module.type.size.width / CanvasViewModel.rate) {
                if y >= 12 || x >= 30 {
                    return
                }
                CanvasViewModel.included[y][x] = false
            }
        }
    }
    
    func addChildVC(_ parentVC : UIViewController,_ childVC : UIViewController,container: UIView) {
        parentVC.addChild(childVC)
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        childVC.willMove(toParent: parentVC)
        childVC.didMove(toParent: parentVC)
    }
}
// MainViewController
extension CanvasViewModel {
    
    func getShadowPosition(_ xPosition: CGFloat,_ yPosition: CGFloat) -> CGPoint {
        let shadowX = Int(xPosition / CGFloat(CanvasViewModel.rate))
        let shadowY = Int(yPosition / CGFloat(CanvasViewModel.rate))
        
        return CGPoint(x: shadowX, y: shadowY)
    }
    
    func setShadow(locationPoint : CGPoint) -> CGRect{
        
        let points = self.getShadowPosition(locationPoint.x, locationPoint.y)
        col = Int(points.x)
        row = Int(points.y)
        
        if row < 0 { row = 0 }
        else if row >= 12 { row = 11 }
        else if col < 0 { col = 0 }
        else if col >= 30 { col = 29 }
        
        if self.checkPosition((row,col), width: Int(SideMenu.sizeOfItem.width), height: Int(SideMenu.sizeOfItem.height)) {
            
            return CGRect(x: points.x * CGFloat(CanvasViewModel.rate), y: points.y * CGFloat(CanvasViewModel.rate), width: SideMenu.sizeOfItem.width, height: SideMenu.sizeOfItem.height)
        } else {
            return CGRect(x: points.x * CGFloat(CanvasViewModel.rate), y: points.y * CGFloat(CanvasViewModel.rate), width: SideMenu.sizeOfItem.width, height: SideMenu.sizeOfItem.height)
        }
    }
    
    func setShadowColor() -> UIColor{
        if self.checkPosition((row,col), width: Int(SideMenu.sizeOfItem.width), height: Int(SideMenu.sizeOfItem.height)) {
            return UIColor.black.withAlphaComponent(0.35)
        } else {
            return UIColor.red.withAlphaComponent(0.35)
        }
    }
    
    func dropModule(locationPoint : CGPoint, module: Module, parentVC: UIViewController){
        let points = self.getShadowPosition(locationPoint.x, locationPoint.y)
        col = Int(points.x)
        row = Int(points.y)
        
        if row < 0 { row = 0 }
        else if row >= 12 { row = 11 }
        else if col < 0 { col = 0 }
        else if col >= 30 { col = 29 }
        
        // Index : For CRUD
        if module.index == nil {
            if self.addModule(module: module) {
                self.setLocation((col, row), module, parentVC: parentVC)
                module.startPoint = CGPoint(x: col, y: row)
            } else {
                parentVC.alert(message: "중복 불가능한 모듈입니다.", title: "중복 불가")
            }
        } else {
            self.setLocation((col, row), module, parentVC: parentVC)
            module.startPoint = CGPoint(x: col, y: row)
        }
    }
}
