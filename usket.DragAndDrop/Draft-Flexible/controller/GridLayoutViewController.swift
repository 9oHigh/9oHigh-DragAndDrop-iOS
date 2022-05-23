//
//  GridViewController.swift
//  usket.DragAndDrop
//
//  Created by Luxrobo on 2022/05/13.
//

import UIKit

final class GridLayoutViewController: UIViewController {
    
    static var status: MenuStatus = .open
    private let sideMenu = SideMenu()
    private let openButton = UIButton()
    let collectionView: UICollectionView = Helper.collectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setConfig()
        view.backgroundColor = .white
    }
    
    func addChildVC(_ childVC : UIViewController,container: UIView) {
        addChild(childVC)
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        childVC.willMove(toParent: self)
        childVC.didMove(toParent: self)
    }
    
    private func setCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)

        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.1)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(75)
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.4)
        }
        
        let imageView = UIImageView(image: UIImage(named: "GridBackground.png"))
        imageView.contentMode = .scaleAspectFit
        collectionView.backgroundView = imageView
    }
    
    private func setConfig(){
        
        view.addSubview(sideMenu)
        view.addSubview(openButton)
        
        openButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        openButton.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        openButton.frame = CGRect(x: view.frame.maxX - 155, y: 0, width: 55, height: 55)
        openButton.backgroundColor = .white
        openButton.layer.cornerRadius = 10
        openButton.tintColor = .black
        openButton.setTitleColor(.black, for: .normal)
        
        sideMenu.frame = CGRect(x: view.frame.maxX - 100, y: 0, width: 100, height: view.frame.height)
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
    
    @IBAction func backToInitial(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
extension GridLayoutViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 319 // 29 * 11 [칸 수]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setPoint(CGPoint(x: Helper.xCounter, y:  Helper.yCounter))
        
        // 29 * 11로 만들기 위해
        Helper.xCounter += 1
        if Helper.xCounter % 29 == 0 {
            Helper.yCounter += 1
            Helper.xCounter = 0
        }
        
        // For Shadow
        if Helper.yCounter < 11 && Helper.gridArray[Helper.xCounter][Helper.yCounter] {
            if Helper.droppedArray[Helper.xCounter][Helper.yCounter]{
                cell.setShadow(UIColor.black.withAlphaComponent(0.35))
                // cell.setShadow(UIColor.red.withAlphaComponent(0.35))
            } else {
                cell.setShadow(UIColor.black.withAlphaComponent(0.35))
            }
        } else {
            cell.resetShadow()
        }
        return cell
    }
}
