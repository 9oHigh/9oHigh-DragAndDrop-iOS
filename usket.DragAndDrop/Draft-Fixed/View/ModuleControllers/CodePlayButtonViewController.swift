//
//  CodePlayButtonViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/20.
//

import UIKit

class ButtonViewController: ModuleViewController {
    let button = UIButton()
    //private var buttonViewModel: ButtonViewModel!
    
    override init(module: Module, size: ModuleSize) {
        super.init(module: module, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        setGesture()
        //buttonViewModel = inject(service: ButtonViewModel.self)
    }
    
    private func setImage() {
        //button.setImage(UIImage(named: module.type.rawValue), for: .highlighted)
        button.setImage(UIImage(named: module.type.rawValue), for: .normal)
    }
    
    private func setGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        button.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            setPressedButtonImage(isPressed: true)
            //buttonViewModel.sendLongPress(isPressed: true)
        case .ended:
            setPressedButtonImage(isPressed: false)
            self.alert(message: "롱프레스 이벤트", title: "버튼 클릭 안내")
            //buttonViewModel.sendLongPress(isPressed: false)
        default:
            break
        }
    }

//    @IBAction func onTouchUp(_ sender: UIButton) {
//        //buttonViewModel.onButtonTouchUp()
//    }

    private func setPressedButtonImage(isPressed: Bool) {
        
//        if isPressed {
//            button.setImage(UIImage(named: "buttonModuleActive"), for: .normal)
//        } else {
//            button.setImage(UIImage(named: "buttonModuleInActive"), for: .normal)
//        }
    }
}
