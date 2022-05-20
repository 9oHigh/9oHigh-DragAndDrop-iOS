//
//  CanvasViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

enum MenuStatus {
    case open
    case closed
}

final class CanvasViewController: UIViewController {
    
    //Sidemenu, Menu Status
    static var status: MenuStatus = .open
    static var rate: CGFloat = 0
    private let sideMenu = SideMenu()
    private let openButton = UIButton()
    
    //Item into Grid
    private let canvasView = CanvasView()
    private let shadowView = UIView()
    
    //ViewModel
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSizeRate()
    }
    
    func setSizeRate(){
        let width: CGFloat = UIScreen.main.bounds.size.width * 0.9
        lazy var height: CGFloat = 272 * width / 704
        setUp(width, height)
        CanvasViewController.rate = width / 29.36255375
        print("RATE:",width,CanvasViewController.rate)
    }
    
    // delegate + addtarget(openButton)
    private func setUp(_ width: CGFloat,_ height: CGFloat){
        
        addChildVC(canvasView, container: view)
        view.addSubview(sideMenu)
        view.addSubview(openButton)
        
        canvasView.view.isUserInteractionEnabled = true
        canvasView.view.addInteraction(UIDropInteraction(delegate: self))
        canvasView.view.frame = CGRect(x: UIScreen.main.bounds.midX - width / 2, y: UIScreen.main.bounds.midY - height / 2.25, width: width, height: height)
        
        openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        openButton.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        openButton.frame = CGRect(x: view.frame.maxX - 155, y: 0, width: 55, height: 55)
        openButton.backgroundColor = .white
        openButton.tintColor = .black
        openButton.setTitleColor(.black, for: .normal)
        
        sideMenu.frame = CGRect(x: view.frame.maxX - 100, y: 0, width: 100, height: view.frame.height)
    }
    
    @IBAction func removeAll(_ sender: UIButton) {
        /*
         - CollectionView
         let viewController = GridLayoutViewController()
         viewController.modalPresentationStyle = .fullScreen
         self.present(viewController, animated: true)
         */
        print(#function)
        for item in canvasView.view.subviews {
            print(item)
            if let tem = item.findViewController() as? ModuleViewController {
                tem.view.removeFromSuperview()
                viewModel.removeModule(module: tem.module, index: tem.module.index!)
                tem.removeFromParent()
            }
        }
        CanvasView.included = [[Bool]](repeating: Array(repeating: false, count: 30),count: 12)
    }
    
    @objc
    private func changeImage(){
        animateView(status: CanvasViewController.status)
        CanvasViewController.status = CanvasViewController.status == .open ? .closed : .open
    }
    
    private func animateView(status: MenuStatus) {
        switch status {
        case .open:
            // 닫기
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.openButton.imageView?.image == UIImage(systemName: "arrow.right") ? self.openButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) : self.openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX, y: 0, width: 0, height: self.view.frame.height)
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 55, y: 0, width: 55, height: 55)
            }, completion: { completed in
                
            })
        case .closed:
            // 열기
            UIView.animate(withDuration: 0.5    , delay: 0.1, options: .curveEaseInOut, animations: {
                self.openButton.imageView?.image == UIImage(systemName: "arrow.right") ? self.openButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) : self.openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX - 100, y: 0, width: 100, height: self.view.frame.height)
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 155, y: 0, width: 55, height: 55)
            }, completion: { completed in
                print(completed)
            })
        }
    }
    
    func addChildVC(_ childVC: UIViewController, container: UIView){
        addChild(childVC)
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        childVC.willMove(toParent: self)
        childVC.didMove(toParent: self)
    }
}
extension CanvasViewController: UIDropInteractionDelegate {
    
    func getShadowPosition(_ xPosition: CGFloat,_ yPosition: CGFloat) -> CGPoint {
        let shadowX = Int(xPosition / CGFloat(CanvasViewController.rate))
        let shadowY = Int(yPosition / CGFloat(CanvasViewController.rate))

        return CGPoint(x: shadowX, y: shadowY)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: Module.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        //print(#function)
        
        let locationPoint = session.location(in: canvasView.view)
        
        canvasView.view.addSubview(shadowView)
        
        let points = self.getShadowPosition(locationPoint.x, locationPoint.y)
        var col = Int(points.x)
        var row = Int(points.y)
        
        if row < 0 { row = 0 }
        else if row >= 12 { row = 11 }
        else if col < 0 { col = 0 }
        else if col >= 30 { col = 29 }
        print("COL AND ROW : ",col,row)
        DispatchQueue.main.async {
            self.shadowView.frame = CGRect(x: points.x * CGFloat(CanvasViewController.rate), y: points.y * CGFloat(CanvasViewController.rate), width: SideMenu.sizeOfItem.width, height: SideMenu.sizeOfItem.height)
            self.shadowView.layer.cornerRadius = 10
            
            if self.canvasView.checkPosition((row,col), width: Int(SideMenu.sizeOfItem.width), height: Int(SideMenu.sizeOfItem.height)) {
                self.shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            } else {
                self.shadowView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
            }
        }
        
        let shadow = shadowView.frame
        let shadowPosition = (col,row)
        //(Int(shadow.minX / CGFloat(CanvasViewController.rate)),Int(shadow.minY / CGFloat(CanvasViewController.rate)))
        print("ShadowPosition:",shadowPosition.0,shadowPosition.1)
        // 하단 초과
        if shadow.minY + shadow.height > canvasView.view.frame.height {
            shadowView.removeFromSuperview()
            return UIDropProposal(operation: .cancel)
            // 우측 초과
        } else if shadow.maxX > canvasView.view.frame.width {
            shadowView.removeFromSuperview()
            return UIDropProposal(operation: .cancel)
        }
        print("CHECK: ",canvasView.checkPosition((shadowPosition.1,shadowPosition.0), width: Int(shadow.width), height: Int(shadow.height)))
        
        if canvasView.checkPosition((shadowPosition.1,shadowPosition.0), width: Int(shadow.width), height: Int(shadow.height)) {
            print("Copy OK")
            return UIDropProposal(operation: .copy)
        }
        print("isForbidden")
        return UIDropProposal(operation: .forbidden)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
        let locationPoint = session.location(in: canvasView.view)
        let points = self.getShadowPosition(locationPoint.x, locationPoint.y)
        var col = Int(points.x)
        var row = Int(points.y)
        
        if row < 0 { row = 0 }
        else if row >= 12 { row = 11 }
        else if col < 0 { col = 0 }
        else if col >= 30 { col = 29 }
        
        session.loadObjects(ofClass: Module.self) { item in
            
            guard let customModule = item.first as? Module else {
                return
            }
        
            DispatchQueue.main.async {
                let points = (col,row)
                // Index : For CRUD
                if customModule.index == nil {
                    if self.viewModel.addModule(module: customModule) {
                        self.canvasView.setLocation((points.0, points.1), customModule)
                        customModule.startPoint = CGPoint(x: points.0, y: points.1)
                    } else {
                        self.alert(message: "중복 불가능한 모듈입니다.", title: "중복 불가")
                    }
                } else {
                    self.canvasView.setLocation((points.0, points.1), customModule)
                    customModule.startPoint = CGPoint(x: points.0, y: points.1)
                }
                // 기존위치에서 시작하기 때문에 위치 초기화
                self.shadowView.frame = CGRect(x: self.view.frame.maxX, y: self.view.frame.maxY, width: 0, height: 0)
            }
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        print(#function)
        
        // 기존위치에서 시작하기 때문에 위치 초기화
        self.shadowView.frame = CGRect(x: self.view.frame.maxX, y: self.view.frame.maxY, width: 0, height: 0)
        self.shadowView.removeFromSuperview()
    }
}
