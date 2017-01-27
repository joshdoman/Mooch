//
//  LogController + Setups.swift
//  Mooch
//
//  Created by Josh Doman on 1/8/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import CoreText

extension LogController {
    
    func setupView() {
        view.addSubview(previewView)
        view.addSubview(takePhoto)
        
        previewView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        previewView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        previewView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        takePhoto.bottomAnchor.constraint(equalTo: previewView.bottomAnchor, constant: -20).isActive = true
        takePhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true
        takePhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        takePhoto.centerXAnchor.constraint(equalTo: previewView.centerXAnchor).isActive = true
        
        let bagButton = createBagButton()
        self.bagButton = bagButton
        
        view.addSubview(bagButton)
        
        _ = bagButton.anchor(previewView.topAnchor, left: previewView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        view.addSubview(editPhotoController.view)
        editPhotoController.view.frame = self.view.bounds
        editPhotoController.setupView()
        editPhotoController.superCategory = "Master"
        editPhotoController.view.isHidden = true
        editPhotoController.delegate = self
        self.addChildViewController(editPhotoController)
    }
    
}
