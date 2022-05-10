//
//  Module.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit
import MobileCoreServices

enum ModuleType : String, Codable {
    
    case buttonModule
    case sendModule
    case dialModule
    case timerModule
    
    enum ErrorType: Error {
        case encoding
        case decoding
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        let decodedValue = try value.decode(String.self)
        
        switch decodedValue {
        case ModuleType.sendModule.rawValue:
            self = .sendModule
        case ModuleType.buttonModule.rawValue:
            self = .buttonModule
        case ModuleType.timerModule.rawValue:
            self = .timerModule
        case ModuleType.dialModule.rawValue:
            self = .dialModule
        default:
            throw ErrorType.decoding
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .buttonModule:
            try container.encode(ModuleType.buttonModule.rawValue)
        case .sendModule:
            try container.encode(ModuleType.sendModule.rawValue)
        case .dialModule:
            try container.encode(ModuleType.dialModule.rawValue)
        case .timerModule:
            try container.encode(ModuleType.timerModule.rawValue)
        }
    }
    
    var imageName: String {
        switch self {
        case .buttonModule:
            return "button"
        case .sendModule:
            return "send"
        case .dialModule:
            return "dial"
        case .timerModule:
            return "timer"
        }
    }
    
    var size: ModuleSize {
        switch self {
        case .buttonModule:
            return ModuleSize(128, 128)
        case .sendModule:
            return ModuleSize(272, 176)
        case .dialModule:
            return ModuleSize(128, 128)
        case .timerModule:
            return ModuleSize(128,224)
        }
    }
}

final class Module : NSObject, NSItemProviderWriting, Codable, NSItemProviderReading {
    
    let type: ModuleType
    var index: Int?
    
    init(type: ModuleType, index: Int? = nil) {
        self.type = type
        self.index = index
    }
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [String(kUTTypeData)]
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [String(kUTTypeData)]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Module {
        do {
            let subject = try JSONDecoder().decode(Module.self, from: data)
            return subject
        } catch {
            fatalError()
        }
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        let progress = Progress(totalUnitCount: 100)
        
        do {
            let data = try JSONEncoder().encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return progress
    }
    
    func setIndex(index: Int){
        self.index = index
    }
    
    func getType() -> ModuleType {
        return self.type
    }
    
    func getIndex() -> Int? {
        return self.index
    }
    
    func toJSON() -> String{
        return """
            {
                type: \(type),
                index : \(String(describing: index))
            }
        """
    }
}

struct ModuleSize {
    
    var height: CGFloat
    var width: CGFloat
    
    init(_ height: CGFloat, _ width: CGFloat){
        self.height = height
        self.width = width
    }
}
