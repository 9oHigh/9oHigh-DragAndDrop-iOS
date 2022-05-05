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

final class Module: UIView, Identifiable {
    
    var moduleType = CustomModuleType.button
    // 해당 뷰를 덮을 뷰가 필요, 현재는 이미지뷰
    var moduleImageView = UIImageView()
    var size: ModuleSize?
    var id: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        addInteraction(UIDragInteraction(delegate: self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initailModule(_ moduleType: CustomModuleType, id: String,image: UIImage){
        
        self.id = id
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
extension Module: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        let location = session.location(in: self)
        let touchedView = self.hitTest(location, with: nil)
        let customModule = getCustomModule(view: touchedView ?? UIView())
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: customModule))
        
        dragItem.localObject = touchedView
        
        return [dragItem]
    }
    func getCustomModule(view: UIView) -> CustomModule {
        
        if let customView = view as? Module {
            switch customView.moduleType {
            case .button:
                return CustomModule(type: .button, index: Int(customView.id!))
            case .send:
                return CustomModule(type: .send, index: Int(customView.id!))
            case .dial:
                return CustomModule(type: .dial, index: Int(customView.id!))
            case .timer:
                return CustomModule(type: .timer, index: Int(customView.id!))
            }
            
        } else {
            print(#function,"ERROR")
            return CustomModule(type: .dial, index: 0)
        }
    }
    //MARK: - REFACTOR
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        print("Session Items:",session.items)
        session.items.forEach { dragItem in
            if let draggedView = dragItem.localObject as? UIView {
                print("DraggedView : ",draggedView)
                
                draggedView.removeFromSuperview()
                print("제거됌?")
                print(session.items)
            }
        }
    }
}
final class CustomModule : NSObject, NSItemProviderWriting, Codable, NSItemProviderReading {
    
    let type: CustomModuleType
    var index: Int?
    
    init(type: CustomModuleType, index: Int? = nil) {
        self.type = type
        self.index = index
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
    
    func setIndex(index:Int){
        self.index = index
    }
    
    func getType() -> CustomModuleType{
        return self.type
    }
    
    func getIndex() -> Int?{
        return self.index
    }
    
    func toJSON() -> String{
        return """
            {
                type: \(type),
                index : \(index)
            }
        """
    }
}
