//
//  EditPhotoController2 + Handlers.swift
//  Mooch
//
//  Created by Josh Doman on 1/12/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit

extension EditPhotoController2 {
    
    func handleCancel() {
        if let row = currentRow {
            hideLabelForRow(row: row)
            currentRow = nil
        }
        currentImage = nil
        self.category = Model.GetCategory(name: "Master")
        self.moveDescriptionView(onScreen: false)
        descriptionContainerView.reset()
        delegate?.hidePhotoController()
        _ = resignFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        _ = descriptionContainerView.resignFirstResponder()
        searchField.resignFirstResponder()
        moveSearchField(onScreen: false)
        return true
    }
    
    //only selects if within range of center icon
    func handleSelectIcon(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: categoryPicker)
        let center = categoryPicker.frame.height / 2
        if abs(location.y - center) < 30 {
            handleSelect()
        }
    }
    
    func handleSelect() {
//        if let row = currentRow, let categories = categories, let superCategory = superCategory {
//            if let row = self.currentRow {
//                self.hideLabelForRow(row: row)
//                self.currentRow = nil
//            }
//            showSearchBar = false
//            movePicker(onScreen: false, label: nil)
//            let when = DispatchTime.now() + 0.2
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                
//                let category = categories[row]
//                self.prevCategories.append(superCategory)
//                self.superCategory = category
//                
//                self.resetSearchField()
//                
//                if self.categories == nil {
//                    self.descriptionContainerView.category = category
//                    self.moveDescriptionView(onScreen: true)
//                } else {
//                    let when = DispatchTime.now() + 0.2
//                    DispatchQueue.main.asyncAfter(deadline: when) {
//                        self.movePicker(onScreen: true, label: "Center")
//                    }
//                }
//            }
//        }
    }
    
    func handleBackFromCategory() {
//        if let row = currentRow, let prevCategory = prevCategories.last, let currCategory = superCategory {
//            self.hideLabelForRow(row: row)
//            startRow = Model.CategoryDictionary[prevCategory]?.getSubcategoryNames()?.index(of: currCategory)
//            self.currentRow = nil
//            movePicker(onScreen: false, label: nil)
//            let when = DispatchTime.now() + 0.2
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                
//                self.prevCategories.removeLast()
//                self.superCategory = prevCategory
//                
//                let when = DispatchTime.now() + 0.2
//                DispatchQueue.main.asyncAfter(deadline: when) {
//                    self.movePicker(onScreen: true, label: currCategory)
//                }
//            }
//        }
    }
    
    func handleBack() {
//        moveDescriptionView(onScreen: false)
//        if let prevCategory = prevCategories.last, let currCategory = superCategory {
//            startRow = Model.CategoryDictionary[prevCategory]?.getSubcategoryNames()?.index(of: currCategory)
//            superCategory = prevCategory
//            prevCategories.removeLast()
//            let when = DispatchTime.now() + 0.2
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                self.movePicker(onScreen: true, label: currCategory)
//            }
//        }
    }
    
    func showLabelForSelectedRow(row: Int) {
//        if let categories = self.categories {
//            let category = categories.count > 0 ? categories[row] : ""
//            
//            for category in categories {
//                labelWidthAnchorsDictionary[category]?.constant = 0
//            }
//            
//            self.labelDictionary[category]?.isHidden = false
//            if let width = self.labelWidthsDictionary[category] {
//                self.labelWidthAnchorsDictionary[category]?.constant = width
//            }
//            
//            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
        
    }
    
    func hideLabelForCategory(category: String) {
        if let label = labelDictionary[category], let widthAnchor = labelWidthAnchorsDictionary[category] {
            DispatchQueue.main.async(execute: {
                widthAnchor.constant = 0
                
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    label.isHidden = true
                })
            })
        }
        
    }
    
    func hideLabelForRow(row: Int) {

    }
    
    func movePicker(onScreen: Bool, label: String?) {
//        if onScreen, let categories = categories, let label = label {
//            if let row = label == "Center" ? categories.count / 2 : categories.index(of: label) {
//                timer?.invalidate()
//                timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
//                    print(row)
//                    self.currentRow = row
//                })
//                let category = categories[row]
//                labelDictionary[category]?.isHidden = false
//                if let width = labelWidthsDictionary[category] {
//                    labelWidthAnchorsDictionary[category]?.constant = width
//                }
//            }
//        }
//        
//        pickerViewRightAnchor?.constant = onScreen ? 0 : 250
//        
//        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
    }
    
    func moveDescriptionView(onScreen: Bool) {
//        backButtonRightAnchor?.constant = onScreen ? -8 : 50
//        descriptionContainerView.isHidden = !onScreen
//        
//        if onScreen {
//            let when = DispatchTime.now() + 0.1
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                self.descriptionContainerView.present()
//            }
//        } else {
//            _ = descriptionContainerView.resignFirstResponder()
//            descriptionViewBottomAnchor?.constant = onScreen ? 0 : 220
//        }
//        
//        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
    }
    
    func placeObjectInBag() {
//        let object = Object()
//        object.title = descriptionContainerView.titleField.text
//        if descriptionContainerView.descriptionTextBox.text != descriptionContainerView.descriptionPlaceholder {
//            object.descriptor = descriptionContainerView.descriptionTextBox.text
//        }
//        object.image = capturedImageView.image
//        if let category = superCategory {
//            prevCategories.append(category)
//            object.categoryPath = prevCategories
//        }
//        delegate?.addObjectToBag(object: object)
    }
    
    func handleSearch() {
        showSearchBar = !showSearchBar
        moveSearchField(onScreen: showSearchBar)
    }
    
    func resetSearchField() {
        mainViewTopAnchor?.constant = 0
        searchField.text = nil
        
        view.layoutIfNeeded()
    }
    
    func moveSearchField(onScreen: Bool) {
        searchViewWidthAnchor?.constant = onScreen ? 200 : 60
        if let height = labelHeight {
            mainViewTopAnchor?.constant = onScreen ? -height : 0
        }
        searchField.isHidden = !onScreen
        if onScreen {
            searchField.becomeFirstResponder()
        } else {
            searchField.resignFirstResponder()
            searchField.text = nil
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

