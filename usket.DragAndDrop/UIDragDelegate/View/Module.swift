//
//  Module.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit
import MobileCoreServices

// MARK: - Module(UIView), ModuleType(Enum:String)

enum ModuleType: String {
    case button
    case dial
    case send
    case timer
}

final class Module: UIView {
    
    var moduleType = CustomModuleType.button
    // 해당 뷰를 덮을 뷰가 필요, 현재는 이미지뷰
    var moduleImageView = UIImageView()
    var size : ModuleSize?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initailModule(_ moduleType: CustomModuleType, image: UIImage){
        
        moduleImageView.image = image
        
        self.moduleType = moduleType
        setModuleType(self.moduleType)
        
        self.addSubview(moduleImageView)
        
        self.moduleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setModuleType(_ moduleType: CustomModuleType){
        
        switch moduleType {
        case .button:
            self.size = ModuleSize(128, 128)
            SideMenu.sizeOfItem = ModuleSize(128, 128)
        case .dial:
            self.size = ModuleSize(128, 128)
            SideMenu.sizeOfItem = ModuleSize(128, 128)
        case .send:
            self.size = ModuleSize(272, 176)
            SideMenu.sizeOfItem = ModuleSize(272, 176)
        case .timer:
            self.size = ModuleSize(128,224)
            SideMenu.sizeOfItem = ModuleSize(128,224)
        }
    }
}
// MARK: - CustomModuleType(String,Codable), CustomModule(For Drag And Drop Object)
enum CustomModuleType : String, Codable {
    
    case button
    case send
    case dial
    case timer
    
    enum ErrorType: Error {
            case encoding
            case decoding
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        let decodedValue = try value.decode(String.self)
        switch decodedValue {
        case ModuleType.send.rawValue:
            self = .send
        case ModuleType.button.rawValue:
            self = .button
        case ModuleType.timer.rawValue:
            self = .timer
        case ModuleType.dial.rawValue:
            self = .dial
        default:
            throw ErrorType.decoding
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .button:
            try container.encode(ModuleType.button.rawValue)
        case .send:
            try container.encode(ModuleType.send.rawValue)
        case .dial:
            try container.encode(ModuleType.dial.rawValue)
        case .timer:
            try container.encode(ModuleType.timer.rawValue)
        }
    }
}

final class CustomModule : NSObject, NSItemProviderWriting, Codable, NSItemProviderReading {
    
    let type : CustomModuleType
    
    init(type:CustomModuleType) {
        self.type = type
    }
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [String(kUTTypeData)]
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
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [String(kUTTypeData)]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> CustomModule {
        do {
            let subject = try JSONDecoder().decode(CustomModule.self, from: data)
            return subject
        } catch {
            fatalError()
        }
    }
}
