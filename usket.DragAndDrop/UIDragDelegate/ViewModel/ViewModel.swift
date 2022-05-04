//
//  ViewModel.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/04.
//

final class ViewModel {
    
    var currentModuleDict: [CustomModuleType : [CustomModule]] = [:]
    
    func addModule(module: CustomModule){
        
        let type = module.getType()
      
        if currentModuleDict[type] != nil {
            currentModuleDict[type]!.append(module)
        } else {
            currentModuleDict[type] = [module]
        }
        
        currentModuleDict[type]?.map{
            print( $0.toJSON())
        }
    }
    
    func removeModule(){
        
    }
    
    func getModuleIndex(module: CustomModule) -> Int {
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

