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
}

