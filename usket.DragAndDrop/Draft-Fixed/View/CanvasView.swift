//
//  CanvasView.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/29.
//

import UIKit

final class CanvasView: UIViewController {
    
    let canvasViewModel = CanvasViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCanvas()
    }
    
    private func setCanvas(){
        
        let gridBackground = UIImageView(image: UIImage(named: "GridBackground.png"))
        gridBackground.contentMode = .scaleAspectFit
        
        view.addSubview(gridBackground)
        
        gridBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
