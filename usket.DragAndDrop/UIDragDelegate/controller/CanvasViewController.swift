import UIKit

//ShadowColor -> 겹치거나 중복 개수를 초과하거나 [RED]

enum MenuStatus {
    case open
    case closed
}

final class CanvasViewController: UIViewController {
    
    //Sidemenu, Menu Status
    private let backgroundGrid = CanvasView(frame: .zero)
    private let sideMenu = SideMenu()
    private let openButton = UIButton()
    private var status: MenuStatus = .open
    private var currentType: CustomModuleType = .button
    
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
        openButton.frame = CGRect(x: view.frame.maxX - 155, y: 0, width: 55, height: 55)
        sideMenu.frame = CGRect(x: view.frame.maxX - 100, y: 0, width: 100, height: view.frame.height)
        
        openButton.backgroundColor = .white
        openButton.layer.cornerRadius = 10
        openButton.tintColor = .black
        openButton.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {

        for item in self.backgroundGrid.subviews where item is Module {
            item.removeFromSuperview()
        }
        self.backgroundGrid.included = [[Bool]](repeating: Array(repeating: false, count: 30),count: 12)
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
extension CanvasViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        print(#function)
        
        //let location = session.location(in: view)
        
        // 여기서 확인 + Provider Preview
        
        /* while
         if let moduleView = view.hitTest(location, with: nil), moduleView is ... {
         
         }
         */
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        
        return [dragItem]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        print(#function)
        
        let target = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))
        
        return UITargetedDragPreview(view: makePreviewImage() , parameters: UIDragPreviewParameters(), target: target)
    }
    
    func makePreviewImage() -> UIImageView {
        print(#function)
        let dragImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SideMenu.sizeOfItem.width, height: SideMenu.sizeOfItem.height))
        let dragImage = UIImage(named: "\(SideMenu.kindOfModule).png")
        dragImageView.image = dragImage
        return dragImageView
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
        print(#function)
    }
    
    func getShadowPosition(_ xPosition: CGFloat,_ yPosition: CGFloat) -> CGPoint {
        let shadowX = Int(xPosition / 24) * 24
        let shadowY = Int(yPosition / 24) * 24
        return CGPoint(x: shadowX, y: shadowY)
    }
}
extension CanvasViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: CustomModule.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print(#function)
        let locationPoint = session.location(in: backgroundGrid)
        
        backgroundGrid.addSubview(shadowView)
        
        DispatchQueue.main.async {
            let points = self.getShadowPosition(locationPoint.x, locationPoint.y)
            var col = Int(points.x / 24)
            var row = Int(points.y / 24)
            
            if row < 0 { row = 0 }
            else if row >= 12 { row = 11 }
            else if col < 0 { col = 0 }
            else if col >= 30 { col = 29 }
            
            self.shadowView.frame = CGRect(x: points.x, y: points.y, width: SideMenu.sizeOfItem.width, height: SideMenu.sizeOfItem.height)
            self.shadowView.layer.cornerRadius = 10
            
            if self.backgroundGrid.checkPosition((row,col), width: Int(SideMenu.sizeOfItem.width), height: Int(SideMenu.sizeOfItem.height)) {
                
                self.shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                self.shadowView.layer.cornerRadius = 10
            } else {
                self.shadowView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            }
        }
        
        if self.sideMenu.tableView.hasActiveDrag {
            if shadowView.frame.minX < 0 || shadowView.frame.maxX > backgroundGrid.frame.maxX || shadowView.frame.minY < 0 || shadowView.frame.maxY > backgroundGrid.frame.maxY {
                print("움직이고있음")
                print(shadowView.frame)
                print(backgroundGrid.frame)
                DispatchQueue.main.async {
                    self.shadowView.removeFromSuperview()
                }
                return UIDropProposal(operation: .cancel)
            }
            return UIDropProposal(operation: .copy)
        } else {
            print("움직이고있지않음")
            if shadowView.frame.minX < 0 || shadowView.frame.maxX > backgroundGrid.frame.maxX || shadowView.frame.minY < 0 || shadowView.frame.maxY > backgroundGrid.frame.maxY {
                
                DispatchQueue.main.async {
                    self.shadowView.removeFromSuperview()
                }
                return UIDropProposal(operation: .cancel)
            }
            return UIDropProposal(operation: .move)
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
        
        if self.shadowView.backgroundColor == UIColor.red.withAlphaComponent(0.2) {
            self.shadowView.removeFromSuperview()
            return
        } else {
            self.shadowView.removeFromSuperview()
        }
        session.loadObjects(ofClass: CustomModule.self) { item in
            
            guard let customModule = item.first as? CustomModule else {
                return
            }
            
            DispatchQueue.main.async {
                let points = self.getShadowPosition(self.shadowView.frame.minX, self.shadowView.frame.minY)
                self.backgroundGrid.setLocation((Int(points.x) / 24, Int(points.y) / 24), customModule.type)
            }
        }
    }
}
