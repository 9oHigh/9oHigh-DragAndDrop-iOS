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
    
    func addModule(module: Module){
        
        let type = module.getType()
        if currentModuleDict[type] != nil {
            currentModuleDict[type]!.append(module)
        } else {
            currentModuleDict[type] = [module]
        }
        module.setIndex(index: currentModuleDict[module.type]!.count)
    }
    
    func removeModule(module: Module, index: Int){
        currentModuleDict[module.type]?.remove(at: index - 1)
        // MARK: - Need Refactor
        // 삭제시 인덱스 고정
        // 맥스번호를 알아야함
        for item in 0 ... currentModuleDict[module.type]!.count - 1{
            if currentModuleDict[module.type]?[item] == nil {
                print(item)
                currentModuleDict[module.type]![item] .index = currentModuleDict[module.type]![item + 1].index
            }
            print(currentModuleDict[module.type]?[item], currentModuleDict[module.type]?[item].index)
        }
    }
    
    func getModuleIndex(module: Module) -> Int {
        return module.index ?? 0
    }
}

