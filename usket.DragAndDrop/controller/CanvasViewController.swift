import UIKit

enum MenuStatus {
    case open
    case closed
}

final class CanvasViewController: UIViewController {
    
    private let sideMenu = SideMenu()
    private let openButton = UIButton()
    @IBOutlet weak var backgroundGrid: UIImageView!
    
    private var status : MenuStatus = .open

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
        
        sideMenu.frame = CGRect(x: view.frame.maxX - 100, y: 0, width: 100, height: view.frame.height)
        openButton.frame = CGRect(x: view.frame.maxX - 145, y: 0, width: 55, height: 55)
        
        openButton.backgroundColor = .lightGray
        openButton.layer.cornerRadius = 10
        openButton.tintColor = .black
        openButton.setTitleColor(.black, for: .normal)
    }
    
    @objc
    private func changeImage(){
        // 1. Frame 조정
        animateView(status: status)
        status = status == .open ? .closed : .open
        
        // 2. On / Off 설정 -> Pending
    }
    
    private func animateView(status: MenuStatus) {
        switch status {
        case .open:
            // 닫기
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
                // 1. 버튼 이미지 변경
                self.openButton.imageView?.image == UIImage(systemName: "arrow.right") ? self.openButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) : self.openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX, y: 0, width: 0, height: self.view.frame.height)
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 45, y: 0, width: 55, height: 55)
            }, completion: { completed in
                print(completed)
            })
        case .closed:
            // 열기
            UIView.animate(withDuration: 0.5    , delay: 0.1, options: .curveEaseInOut, animations: {
                // 1. 버튼 이미지 변경
                self.openButton.imageView?.image == UIImage(systemName: "arrow.right") ? self.openButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) : self.openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                
                self.sideMenu.frame = CGRect(x: self.view.frame.maxX - 100, y: 0, width: 100, height: self.view.frame.height)
                self.openButton.frame = CGRect(x: self.view.frame.maxX - 145, y: 0, width: 55, height: 55)
            }, completion: { completed in
                print(completed)
            })
        }
    }
    
    func createPreviewProvider() -> UIDragPreview{

        let dragImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        let dragImage = UIImage(named: "ButtonModule")

        dragImageView.image = dragImage
        dragImageView.isUserInteractionEnabled = true

        return UIDragPreview(view: dragImageView)
    }
}
extension CanvasViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {

        let location = session.location(in: self.view)

        print("스타트 위치:",location)

        if let imageView = self.view.hitTest(location, with: nil) as? UIImageView {

            let dragImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))

            let dragImage = UIImage(named: "ButtonModule")
            dragImageView.image = dragImage

            let itemProvider = NSItemProvider(object: dragImageView.image as! NSItemProviderWriting)

            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = imageView
            dragItem.previewProvider = createPreviewProvider

            return [dragItem]

        }
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {

        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
        print(#function)
        print("위치좀 알려주라",session.location(in: self.view))
    }
}
extension CanvasViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print(#function)
        return session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print(#function)
        let dropLocation = session.location(in: backgroundGrid)
        
        if dropLocation.x < backgroundGrid.frame.minX || dropLocation.x > backgroundGrid.frame.maxX {
            return UIDropProposal(operation: .cancel)
        } else if dropLocation.y < backgroundGrid.frame.minY || dropLocation.y > backgroundGrid.frame.maxY {
            return UIDropProposal(operation: .cancel)
        } else {
            return UIDropProposal(operation: .move)
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
        let dropLocation = session.location(in: backgroundGrid)
        let dropLocationView = session.location(in: view)
        print("드롭 로케이션 grid:",dropLocation)
        print("드롭 로케이션 view:",dropLocationView)
        
        for dragItem in session.items {

            dragItem.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] object, error in

                if error != nil {
                    print("Failed");
                    return
                    
                }
                guard let dragImage = object as? UIImage else { return
                    
                }
                DispatchQueue.main.async {
                    let dragImageView = UIImageView(image: dragImage)
                    dragImageView.isUserInteractionEnabled = true
                    //Method를 통해 현재위치 -> 저장할 위치
                    
                    dragImageView.frame = CGRect(x: dropLocation.x, y: dropLocation.y, width: dragImage.size.width, height: dragImage.size.width)
                    print("드래그중 뷰의 사이즈:",dragImage.size)
                    print("뷰컨의 뷰의 프레임:",self?.view.frame)
                    print("그리드 이미지뷰 사이즈:",self?.backgroundGrid.frame)
                    print("파이널 위치:",dragImageView.frame)
                    self?.backgroundGrid.addSubview(dragImageView)
                }
            }
        }
    }
}
