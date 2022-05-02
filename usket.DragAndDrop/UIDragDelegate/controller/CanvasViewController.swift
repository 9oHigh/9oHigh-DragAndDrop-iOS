import UIKit

enum MenuStatus {
    case open
    case closed
}

final class CanvasViewController: UIViewController {
    
    //Sidemenu, Menu Status
    private let backgroundGrid = CanvasView(frame: .zero)
    private let sideMenu = SideMenu()
    private let openButton = UIButton()
    private var status : MenuStatus = .open
    
    //Item into Grid
    private let shadowView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    // delegate + addtarget(openButton)
    private func setUp(){
        
        view.addInteraction(UIDragInteraction(delegate: self))
        view.addInteraction(UIDropInteraction(delegate: self))
        
        view.addSubview(backgroundGrid)
        view.addSubview(sideMenu)
        view.addSubview(openButton)
        
        backgroundGrid.isUserInteractionEnabled = true
        backgroundGrid.frame = CGRect(x: UIScreen.main.bounds.midX - 352, y: UIScreen.main.bounds.midY - 118, width: 704, height: 272)
        
        openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        openButton.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        openButton.frame = CGRect(x: view.frame.maxX - 145, y: 0, width: 55, height: 55)
        sideMenu.frame = CGRect(x: view.frame.maxX - 100, y: 0, width: 100, height: view.frame.height)
        
        openButton.backgroundColor = .lightGray
        openButton.layer.cornerRadius = 10
        openButton.tintColor = .black
        openButton.setTitleColor(.black, for: .normal)
    }
    
    @objc
    private func changeImage(){
        animateView(status: status)
        status = status == .open ? .closed : .open
    }
    
    private func animateView(status: MenuStatus) {
        switch status {
        case .open:
            // 닫기
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
                self.openButton.imageView?.image == UIImage(systemName: "arrow.right") ? self.openButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) : self.openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX, y: 0, width: 0, height: self.view.frame.height)
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 45, y: 0, width: 55, height: 55)
            }, completion: { completed in
                
            })
        case .closed:
            // 열기
            UIView.animate(withDuration: 0.5    , delay: 0.1, options: .curveEaseInOut, animations: {
                self.openButton.imageView?.image == UIImage(systemName: "arrow.right") ? self.openButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) : self.openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX - 100, y: 0, width: 100, height: self.view.frame.height)
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 145, y: 0, width: 55, height: 55)
            }, completion: { completed in
                print(completed)
            })
        }
    }
}
extension CanvasViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        print(#function)
        
        let location = session.location(in: view)
        
        if let draggingView = self.view.hitTest(location, with: nil) {
            let startView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
            
            startView.image = UIImage(named: "ButtonModule.png")
            
            let itemProvider = NSItemProvider(object: startView.image!)
            
            let draggingItem = UIDragItem(itemProvider: itemProvider)
            draggingItem.localObject = draggingView
            draggingItem.previewProvider = createPreviewProvider
            
            return [draggingItem]
        }
        return []
    }
    
    private func createPreviewProvider() -> UIDragPreview {
        print(#function)
        let draggingView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        let dragImage = UIImage(named: "ButtonModule.png")
        
        draggingView.image = dragImage
        draggingView.isUserInteractionEnabled = true
        
        return UIDragPreview(view: draggingView)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        print(#function)
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
        print(#function)
        
        let locationPoint = session.location(in: backgroundGrid)
        backgroundGrid.addSubview(shadowView)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            let points = self.setShadow(locationPoint.x, locationPoint.y)
            var col = Int(points.x / 24)
            var row = Int(points.y / 24)
            
            if row < 0 { row = 0 }
            else if col < 0 { col = 0 }
            
            print(self.backgroundGrid.checkPosition((row,col), width: 128, height: 128))
            
            if self.backgroundGrid.checkPosition((row,col), width: 128, height: 128) {
                // 새로운 위치에 그림자 넣어줘야함
                
                // x포지션의 이동으로 가능한경우 함수로 가능한 포인트 찾아서 반환 + setFrame
                
                // y포지션의 이동으로 가능한 경우 함수로 가능한 포인트 찾아서 반환 + setFrame
                
                // x,y 둘다 변경하면서 찾아야하는 경우 함수로 찾고 반환 + setFrame
                
            } else {
                self.shadowView.frame = CGRect(x: points.x, y: points.y, width: 128, height: 128)
                self.shadowView.layer.cornerRadius = 10
            }
        }
    }
    
    func setShadow(_ xPosition: CGFloat,_ yPosition: CGFloat) -> CGPoint {
        let shadowX = Int(xPosition / 24) * 24
        let shadowY = Int(yPosition / 24) * 24
        
        return CGPoint(x: shadowX, y: shadowY)
    }
}
extension CanvasViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print(#function)
        
        let locationPoint = session.location(in: backgroundGrid)
        let points = self.setShadow(locationPoint.x, locationPoint.y)
        var col = Int(points.x / 24)
        var row = Int(points.y / 24)
        
        if row < 0 { row = 0 }
        else if col < 0 { col = 0 }

        if self.backgroundGrid.checkPosition((row,col), width: 128, height: 128) {
            return UIDropProposal(operation: .cancel)
        }
        
        if shadowView.frame.minX < 0 || shadowView.frame.maxX > backgroundGrid.frame.width {
            DispatchQueue.main.async {
                self.shadowView.removeFromSuperview()
            }
            return UIDropProposal(operation: .cancel)
        } else if shadowView.frame.minY < 0 || shadowView.frame.maxY > backgroundGrid.frame.height {
            DispatchQueue.main.async {
                self.shadowView.removeFromSuperview()
            }
            return UIDropProposal(operation: .cancel)
        }  else {
            return UIDropProposal(operation: .move)
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
        
        self.shadowView.removeFromSuperview()
        
        for dragItem in session.items {
            
            dragItem.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                
                if error != nil {
                    print("Failed");
                    return
                }
                
                let location = session.location(in: self!.backgroundGrid)
                
                DispatchQueue.main.async {
                    let points = self?.setShadow(location.x, location.y)
                    self?.backgroundGrid.setLocation((Int(points?.x ?? 24) / 24, Int(points?.y ?? 24) / 24), .button)
                }
            }
        }
    }
}
