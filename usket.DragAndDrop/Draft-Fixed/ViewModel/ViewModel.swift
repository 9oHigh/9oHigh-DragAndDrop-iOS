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
    }
    
    func removeModule(){
        
    }
    
    func getModuleIndex(module: Module) -> Int {
        var index = 1
        let type = module.getType()

        guard var sameModules = currentModuleDict[type] else {
            return index
        }
        
        sameModules.sort {
            $0.getIndex()! < $1.getIndex()!
        }
        for i in 1 ..< sameModules.count + 2 {
            let foundModule = sameModules.first { $0.getIndex() == i
            }
            if foundModule == nil {
                index = i
                break
            }
        }
        return index
    }
}

