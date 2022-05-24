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
        setSizeByRatio()
    }
    
    func setSizeByRatio(){
        let width: CGFloat = canvasView.canvasWidth
        let height: CGFloat = canvasView.oldHeight * width / canvasView.oldWidth
        
        CanvasViewModel.rate = width / canvasView.ratio
        setUp(width, height)
    }

    private func setUp(_ width: CGFloat,_ height: CGFloat){
        
        viewModel.addChildVC(self, canvasView, container: view)
        view.addSubview(sideMenu)
        view.addSubview(openButton)
        
        canvasView.view.addInteraction(UIDropInteraction(delegate: self))
        canvasView.view.frame = CGRect(x: UIScreen.main.bounds.midX - width / 2, y: UIScreen.main.bounds.midY - height / 2.25, width: width, height: height)
        
        setSideMenu()
    }
    
    // Snapkit 사용하기
    private func setSideMenu(){
        
        openButton.setImage(UIImage(named: "Arrow.right"), for: .normal)
        openButton.frame = CGRect(x: view.frame.maxX - 145, y: 30, width: 50, height: 70)
        openButton.backgroundColor = .white
        openButton.tintColor = .black
        openButton.layer.cornerRadius = 5
        openButton.setShadow()
        openButton.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        
        sideMenu.frame = CGRect(x: view.frame.maxX - 100, y: 0, width: 100, height: view.frame.height)
    }
    
    @objc
    private func changeImage(){
        animateView(status: CanvasViewModel.status)
        CanvasViewModel.status = CanvasViewModel.status == .open ? .closed : .open
    }
    
    private func animateView(status: MenuStatus) {
        switch status {
            // 닫기
        case .open:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.openButton.imageView?.image == UIImage(named: "Arrow.right") ? self.openButton.setImage(UIImage(named: "Arrow.left"), for: .normal) : self.openButton.setImage(UIImage(named: "Arrow.right"), for: .normal)
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX, y: 0, width: 100, height: self.view.frame.height)
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 45, y: 30, width: 50, height: 70)
                
            }, completion: { completed in
                self.sideMenu.unsetShadow()
            })
            // 열기
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.openButton.imageView?.image == UIImage(named: "Arrow.right") ? self.openButton.setImage(UIImage(named: "Arrow.left"), for: .normal) : self.openButton.setImage(UIImage(named: "Arrow.right"), for: .normal)
                
                self.sideMenu.setShadow()
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX - 100, y: 0, width: 100, height: self.view.frame.height)
                
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 145, y: 30, width: 50, height: 70)
            }, completion: { completed in
                
            })
        }
    }
}
extension MainViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        
        return session.canLoadObjects(ofClass: Module.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {

        canvasView.view.addSubview(shadowView)

        DispatchQueue.main.async { [self] in
            
            let location = session.location(in: canvasView.view)
            self.shadowView.frame = self.viewModel.setShadow(location: location)
            
            self.shadowView.layer.cornerRadius = 10
            self.shadowView.backgroundColor = viewModel.setShadowColor()
        }
        // 쉐도우 프레임
        let frame = shadowView.frame
        // 하단 초과
        if frame.minY + frame.height > canvasView.view.frame.height {
            shadowView.removeFromSuperview()
            return UIDropProposal(operation: .cancel)
        // 우측 초과
        } else if frame.maxX > canvasView.view.frame.width {
            shadowView.removeFromSuperview()
            return UIDropProposal(operation: .cancel)
        }
        
        if viewModel.checkPosition((viewModel.row,viewModel.col), width: Int(frame.width), height: Int(frame.height)) {
            print("Copy")
            return UIDropProposal(operation: .copy)
        }
        print("isForbidden")
        return UIDropProposal(operation: .forbidden)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {

        session.loadObjects(ofClass: Module.self) { item in
            
            guard let customModule = item.first as? Module else {
                return
            }
            
            DispatchQueue.main.async {
                
                let location = session.location(in: self.canvasView.view)
                
                self.viewModel.dropModule(location: location, module: customModule,parentVC: self.canvasView)
                
                // 기존위치에서 시작하기 때문에 위치 초기화
                self.shadowView.frame = CGRect(x: self.view.frame.maxX, y: self.view.frame.maxY, width: 0, height: 0)
            }
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        // 기존위치에서 시작하기 때문에 위치 초기화
        self.shadowView.frame = CGRect(x: self.view.frame.maxX, y: self.view.frame.maxY, width: 0, height: 0)
        self.shadowView.removeFromSuperview()
    }
}
