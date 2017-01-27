//
//  PresentObjectsController.swift
//  Mooch
//
//  Created by Josh Doman on 1/9/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit

protocol PresentObjectsDelegate: class {
    func handleNext()
}

class PresentObjectsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var objects: [Object]?
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Back-arrow-right")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Edit")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 1
        button.layer.shouldRasterize = true
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
        view.addSubview(backButton)
        view.addSubview(editButton)
        
        _ = backButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 44, heightConstant: 44)
        
        _ = editButton.anchor(nil, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 30, heightConstant: 30)
        editButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        
        collectionView?.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleNext))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        collectionView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    let objectCellId = "objectCellId"
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        if let objects = self.objects {
            pc.numberOfPages = objects.count + 1
        }
        return pc
    }()
    
    fileprivate func registerCells() {
        collectionView?.register(ObjectCell.self, forCellWithReuseIdentifier: objectCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let objects = objects {
            return objects.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height) //makes cell size of frame
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: objectCellId, for: indexPath) as! ObjectCell
        if let objects = objects {
            cell.object = objects[indexPath.row]
        }
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    func handleExit() {
        dismiss(animated: false, completion: nil)
    }
    
    func handleNext() {
        pageControl.currentPage += 1
        
        let currentPage = pageControl.currentPage
        if let count = self.objects?.count {
            if currentPage >= 0 && currentPage < count {
                let indexPath = IndexPath(item: currentPage, section: 0)
                collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            } else {
                handleExit()
            }
        }
    }
    
    func handleEdit() {
        let index = IndexPath(item: pageControl.currentPage, section: 0)
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: objectCellId, for: index) as! ObjectCell
        cell.handleEdit()
        collectionView?.isScrollEnabled = false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    
}

