//
//  ViewModel.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/04.
//

// MARK: Need Refactor
/// 1. CRUD ( 추가, 수정, 제거 ... )
/// 2. 기존의 저장된 정보를 불러오는 방법론이 필요

final class ViewModel {
    
    var currentModuleDict: [ModuleType : [Module]] = [:]
    
    func addModule(module: Module) -> Bool{
        
        if currentModuleDict[module.type] == nil {
            currentModuleDict[module.type] = [module]
            module.index = 1
            return true
        } else {
            if module.type.max <= currentModuleDict[module.type]!.count {
                if module.index != nil {
                    return true
                }
                return false
            }
            currentModuleDict[module.type]!.append(module)
            for index in 0...currentModuleDict[module.type]!.count - 1 {
                if currentModuleDict[module.type]?[index].index == nil {
                    currentModuleDict[module.type]![index].index = index + 1
                    module.index = index + 1
                    return true
                }
            }
            return false
        }
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
    
    func getModuleIndex(module: Module) -> Int {
        return module.index ?? 0
    }
}

