//
//  CanvasView.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

final class CanvasView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCanvas()
    }
    
    private func setCanvas(){
        
        view.isUserInteractionEnabled = true
        
        let gridBackground = UIImageView(image: UIImage(named: "GridBackground.png"))
        gridBackground.contentMode = .scaleAspectFit
        
        view.addSubview(gridBackground)
        
        gridBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension CanvasView {
    
    var canvasWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.9
    }
    
    var oldHeight: CGFloat {
        return 272
    }
    
    var oldWidth: CGFloat {
        return 704
    }
    
    var ratio: CGFloat {
        return 29.3333
    }
}
