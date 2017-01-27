//
//  ObjectCell.swift
//  Mooch
//
//  Created by Josh Doman on 1/9/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit

class ObjectCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var object: Object? {
        didSet {
            if let object = object {
                imageView.image = object.image
                descriptionView.setupForObject(object: object)
                setupView()
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        return iv
    }()
        
    let descriptionView: DescriptionView = DescriptionView()
    
    var delegate: PresentObjectsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(imageView)
        addSubview(descriptionView)
        
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        _ = descriptionView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: descriptionView.height)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleNext))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleNext() {
        delegate?.handleNext()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleEdit() {
        print("cell edit")
    }
}
