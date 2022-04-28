//
//  CumstomImageView.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/04/28.
//

import UIKit

final class customImageView: UIImageView {
    
    var moduleView = UIView()
    var originPoint: CGPoint? //시작 위치
    var width: CGFloat?
    var height: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let width = width, let height = height, let originPoint = originPoint {
            self.frame = CGRect(x: originPoint.x, y: originPoint.y, width: width, height: height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //moduleView로 변환
    func changeToModuleView(){
        moduleView.isUserInteractionEnabled = true
        addSubview(moduleView)
        moduleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
