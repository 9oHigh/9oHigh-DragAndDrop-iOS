//
//  CanvasViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let sideMenu = SideMenu()
    private let openButton = UIButton()
    
    let canvasView = CanvasView()
    private var shadowView = UIView()
    
    let viewModel = CanvasViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSizeRate()
    }
    
    func setSizeRate(){
        let width: CGFloat = canvasView.canvasWidth
        lazy var height: CGFloat = canvasView.oldHeight * width / canvasView.oldWidth
        setUp(width, height)
        CanvasViewModel.rate = width / canvasView.ratio
    }
    
    // delegate + addtarget(openButton)
    private func setUp(_ width: CGFloat,_ height: CGFloat){
        
        viewModel.addChildVC(self, canvasView, container: view)
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
        print(#function)
        for item in canvasView.view.subviews {
            if let tem = item.findViewController() as? ModuleViewController {
                tem.view.removeFromSuperview()
                viewModel.removeModule(module: tem.viewModel.module, index: tem.viewModel.module.index!)
                tem.removeFromParent()
            }
        }
        CanvasViewModel.included = [[Bool]](repeating: Array(repeating: false, count: 30),count: 12)
    }
    
    @objc
    private func changeImage(){
        animateView(status: CanvasViewModel.status)
        CanvasViewModel.status = CanvasViewModel.status == .open ? .closed : .open
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
}
extension MainViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: Module.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        //print(#function)
        
        let locationPoint = session.location(in: canvasView.view)
        
        canvasView.view.addSubview(shadowView)

        DispatchQueue.main.async { [self] in
            self.shadowView.frame = self.viewModel.setShadow(locationPoint: locationPoint)
            self.shadowView.backgroundColor = viewModel.setShadowColor()
            
            self.shadowView.layer.cornerRadius = 10
        }
        
        let shadow = shadowView.frame

        // 하단 초과
        if shadow.minY + shadow.height > canvasView.view.frame.height {
            shadowView.removeFromSuperview()
            return UIDropProposal(operation: .cancel)
            // 우측 초과
        } else if shadow.maxX > canvasView.view.frame.width {
            shadowView.removeFromSuperview()
            return UIDropProposal(operation: .cancel)
        }
        
        if self.viewModel.checkPosition((viewModel.row,viewModel.col), width: Int(shadow.width), height: Int(shadow.height)) {
            print("Copy")
            return UIDropProposal(operation: .copy)
        }
        print("isForbidden")
        return UIDropProposal(operation: .forbidden)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
        let locationPoint = session.location(in: canvasView.view)
       
        session.loadObjects(ofClass: Module.self) { item in
            
            guard let customModule = item.first as? Module else {
                return
            }
            
            DispatchQueue.main.async {
                
                self.viewModel.dropModule(locationPoint: locationPoint, module: customModule,parentVC: self.canvasView)

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
