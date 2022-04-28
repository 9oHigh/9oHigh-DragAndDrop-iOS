import UIKit

enum MenuStatus {
    case open
    case closed
}

final class CanvasViewController: UIViewController {
    
    //Grid
    @IBOutlet weak var backgroundGrid: UIImageView!
    
    //Sidemenu, Menu Status
    private let sideMenu = SideMenu()
    private let openButton = UIButton()
    private var status : MenuStatus = .open
    
    //Item into Grid
    private let shadowView = UIView()
    var itemList: [customImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    // delegate + addtarget(openButton)
    private func setUp(){
        
        view.addInteraction(UIDragInteraction(delegate: self))
        view.addInteraction(UIDropInteraction(delegate: self))
        
        backgroundGrid.isUserInteractionEnabled = true
        
        view.addSubview(sideMenu)
        view.addSubview(openButton)
        
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
                print(completed)
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
        
        let location = session.location(in: backgroundGrid)
        
        if let customView = self.view.hitTest(location, with: nil) {
            print("아이템 리스트:",itemList,itemList.count)
            let dragImageView = customImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
            
            let dragImage = UIImage(named: "ButtonModule")
            dragImageView.image = dragImage
            
            let itemProvider = NSItemProvider(object: dragImageView.image!)
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = customView
            dragItem.previewProvider = createPreviewProvider
            
            return [dragItem]
        }
        return []
    }
    
    private func createPreviewProvider() -> UIDragPreview {
        print(#function)
        let draggingView = customImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        let dragImage = UIImage(named: "ButtonModule")
        
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
            self.shadowView.frame = CGRect(x: locationPoint.x , y: locationPoint.y - 70, width: 140, height: 140)
            self.shadowView.layer.cornerRadius = 10
        }
        // print("위치좀 알려주라",session.location(in: backgroundGrid))
    }
}
extension CanvasViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print(#function)
        // print("그림자 프레임",shadowView.frame)
        // print("그리드 프레임",backgroundGrid.frame)
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
        } else {
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
                guard let dragImage = object as? UIImage else { return
                }
                DispatchQueue.main.async {
                    
                    let dragImageView = customImageView(frame: .zero)
                    dragImageView.image =  dragImage
                    dragImageView.isUserInteractionEnabled = true
                    
                    self?.backgroundGrid.addSubview(dragImageView)
                    self?.itemList.append(dragImageView)
                    
                    dragImageView.frame = CGRect(x: self!.shadowView.frame.minX, y: self!.shadowView.frame.minY, width: dragImage.size.width, height: dragImage.size.width)
                    dragImageView.changeToModuleView()
                }
            }
        }
    }
}
