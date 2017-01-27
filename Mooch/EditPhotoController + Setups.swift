//
//  EditPhotoController + Setups.swift
//  Mooch
//
//  Created by Josh Doman on 1/9/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import CoreText

extension EditPhotoController {
    
    func setupView() {        
        view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(capturedImageView)
        view.addSubview(cancelButton)
        
        capturedImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        capturedImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        capturedImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        capturedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        view.addSubview(pickerView)
        
        pickerViewRightAnchor = pickerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 200)
        pickerViewRightAnchor?.isActive = true
        pickerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mainViewTopAnchor = pickerView.topAnchor.constraint(equalTo: view.topAnchor)
        mainViewTopAnchor?.isActive = true
        pickerView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        capturedImageView.addSubview(descriptionContainerView)
        
        descriptionViewBottomAnchor = descriptionContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 220)
        descriptionViewBottomAnchor?.isActive = true
        descriptionContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        descriptionViewHeightAnchor = descriptionContainerView.heightAnchor.constraint(equalToConstant: descriptionContainerView.height)
        descriptionViewHeightAnchor?.isActive = true
        descriptionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionContainerView.delegate = self
        descriptionContainerView.isHidden = true
        
        view.addSubview(backButton)
        
        backButtonRightAnchor = backButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: -50, widthConstant: 44, heightConstant: 44)[1]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSelectIcon))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        categoryPicker.addGestureRecognizer(tapGestureRecognizer)
        categoryPicker.isUserInteractionEnabled = true
        
        searchField.delegate = self
    }
    
    func setupNewPicker(categories: [String], mainView: UIView, picker: UIPickerView, backgroundView: UIView, select: UIButton) {
        
        if showSearchBar {
            setupPicker(categories: categories, mainView: mainView, backgroundView: backgroundView, picker: picker, select: select)
        } else {
            
            backgroundView.removeFromSuperview()
            picker.removeFromSuperview()
            select.removeFromSuperview()
            titleLabel?.removeFromSuperview()
            titleBackView?.removeFromSuperview()
            titleBackView2?.removeFromSuperview()
            backButton2.removeFromSuperview()
            searchView1?.removeFromSuperview()
            searchView2?.removeFromSuperview()
            searchButton.removeFromSuperview()
            searchField.removeFromSuperview()
            
            showSearchBar = false
            
            if self.superCategory! != "Master" {
                addTitle(text: superCategory!, myView: mainView)
            } else {
                addTitle(text: "Choose a category", myView: mainView)
            }
            
            setupPicker(categories: categories, mainView: mainView, backgroundView: backgroundView, picker: picker, select: select)
            
            let searchView = UIView()
            
            mainView.addSubview(searchView)
            searchViewWidthAnchor = searchView.anchor(titleLabel?.bottomAnchor, left: nil, bottom: nil, right: mainView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)[2]
            
            if let row = startRow {
                categoryPicker.selectRow(row, inComponent: 0, animated: false)
                startRow = nil
            } else {
                let middleOfPicker = categories.count / 2
                categoryPicker.selectRow(middleOfPicker, inComponent: 0, animated: false)
            }
            selectMiddleIcon()
            self.searchView = searchView
            setupSearchView()
            
        }
    }
    
    func selectMiddleIcon() {
        if let categories = categories {
            let middleOfPicker = categories.count / 2
            self.currentRow = middleOfPicker
        }
    }
    
    func setupPicker(categories: [String], mainView: UIView, backgroundView: UIView, picker: UIPickerView, select: UIButton) {
        backgroundView.removeFromSuperview()
        picker.removeFromSuperview()
        select.removeFromSuperview()
        
        for label in categoryLabels {
            label.removeFromSuperview()
        }
                
        createLabelsAddToDictionaryAndToSuperView(categories: categories, view: mainView)
        
        mainView.addSubview(backgroundView)
        _ = backgroundView.anchor(titleLabel?.bottomAnchor, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, topConstant: 60, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        mainView.addSubview(select)
        select.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -30).isActive = true
        select.widthAnchor.constraint(equalToConstant: 50).isActive = true
        select.heightAnchor.constraint(equalToConstant: 50).isActive = true
        select.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        
        mainView.addSubview(picker)
        _ = picker.anchor(mainView.topAnchor, left: nil, bottom: mainView.bottomAnchor, right: nil, topConstant: 100, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 60, heightConstant: 0)
        picker.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        picker.dataSource = self
        picker.delegate = self
        
        addLabelsToPicker(categories: categories, picker: picker, view: mainView)
    }
    
    func addTitle(text: String, myView: UIView) {
        let font = UIFont.systemFont(ofSize: 40)
        let attributes = NSDictionary(object: font, forKey:NSFontAttributeName as NSCopying)
        let size = text.size(attributes: (attributes as! [String : AnyObject]))
        
        let width = min(max(150, size.width), 200)
        let height = size.width > 200 ? size.height * 2 + 10 : size.height + 20
        self.labelHeight = height
        
        let backView = UIView()
        myView.addSubview(backView)
        _ = backView.anchor(myView.topAnchor, left: nil, bottom: nil, right: myView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 60, widthConstant: width - 60, heightConstant: height)[3]
        
        backView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let label = UILabel(frame: CGRect(x: -width + 50, y: 0, width: width, height: height))
        label.font = font
        label.textColor = .white
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .right
        
        let gradientMask = CAGradientLayer()
        
        gradientMask.frame = label.bounds
        gradientMask.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientMask.startPoint = CGPoint(x: 0.5, y: 0.5);
        gradientMask.endPoint = CGPoint(x: 0.0, y: 0.5);
        
        let maskView: UIView = UIView()
        maskView.layer.addSublayer(gradientMask)
        
        backView.mask = maskView
        
        let backView2 = UIView()
        backView2.backgroundColor = UIColor(white: 0, alpha: 0.5)
        myView.addSubview(backView2)
        _ = backView2.anchor(myView.topAnchor, left: nil, bottom: nil, right: myView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: height)
        
        titleLabel = label
        titleBackView = backView
        titleBackView2 = backView2
        
        backView2.addSubview(label)
        
        if superCategory != "Master" {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBackFromCategory))
            tapGestureRecognizer.numberOfTapsRequired = 1
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGestureRecognizer)
            
            label.addSubview(backButton2)
            let words = getLinesArrayOfStringInLabel(label: label)
            
            var labelWidth: CGFloat = 0
            for word in words {
                let font = UIFont.systemFont(ofSize: 40)
                let attributes = NSDictionary(object: font, forKey:NSFontAttributeName as NSCopying)
                let size = word.size(attributes: (attributes as! [String : AnyObject]))
                labelWidth = max(labelWidth, size.width)
            }
            
            _ = backButton2.anchor(nil, left: nil, bottom: nil, right: titleLabel?.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: labelWidth + 4, widthConstant: 40, heightConstant: 40)
            backButton2.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        }
    }
    
    func addLabelsToPicker(categories: [String], picker: UIPickerView, view: UIView) {
        for categoryName in categories {
            let font = UIFont.systemFont(ofSize: 24)
            let attributes = NSDictionary(object: font, forKey:NSFontAttributeName as NSCopying)
            let size = categoryName.size(attributes: (attributes as! [String : AnyObject]))
            
            if let label = labelDictionary[categoryName] {
                label.centerYAnchor.constraint(equalTo: picker.centerYAnchor).isActive = true
                let width = size.width + 20
                
                let labelRightAnchor = label.rightAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
                labelRightAnchor.isActive = true
                labelRightAnchorsDictionary[categoryName] = labelRightAnchor
                
                let labelWidthAnchor = label.widthAnchor.constraint(equalToConstant: 0)
                labelWidthAnchor.isActive = true
                
                labelWidthAnchorsDictionary[categoryName] = labelWidthAnchor
                labelWidthsDictionary[categoryName] = width
                
                label.heightAnchor.constraint(equalToConstant: size.height + 10).isActive = true
                
                label.isHidden = true
            }
        }
        picker.reloadAllComponents()
    }
    
    func createLabelsAddToDictionaryAndToSuperView(categories: [String], view: UIView) {
        categoryLabels = [UILabel]()
        for category in categories {
            //if labelDictionary[category] == nil {
                let label = UILabel()
                
                view.insertSubview(label, at: 0)
                
                label.text = category
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 24)
                label.backgroundColor = UIColor(white: 0, alpha: 0.5)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textAlignment = .center
                
                labelDictionary[category] = label
                categoryLabels.append(label)
           //}
        }
    }
    
    //assumes left justified
    //returns the words on each line of label (spaces removed)
    func getLinesArrayOfStringInLabel(label:UILabel) -> [String] {
        guard label.text != nil else {
            return [String]()
        }
        
        let text:NSString = label.text! as NSString
        let font:UIFont = label.font
        let rect:CGRect = label.frame
        
        let myFont:CTFont = CTFontCreateWithName(font.fontName as CFString?, font.pointSize, nil)
        let attStr:NSMutableAttributedString = NSMutableAttributedString(string: text as String)
        attStr.addAttribute(String(kCTFontAttributeName), value:myFont, range: NSMakeRange(0, attStr.length))
        let frameSetter:CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path: CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100000))
        let frame:CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as NSArray
        var linesArray = [String]()
        
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range:NSRange = NSMakeRange(lineRange.location, lineRange.length)
            let lineString = text.substring(with: range)
            linesArray.append(lineString as String)
        }
        
        var modifiedWords = [String]()
        for word in linesArray {
            var tempWord = word
            if let start = word.characters.first {
                if start == " " {
                    tempWord.remove(at: word.startIndex)
                }
            }
            if let end = word.characters.last {
                if end == " " {
                    tempWord.remove(at: word.index(word.endIndex, offsetBy: -1))
                }
            }
            modifiedWords.append(tempWord)
        }
        
        return modifiedWords
    }
    
    func setupSearchView() {
        if let searchView = searchView {
            let backView1 = UIView()
            backView1.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            searchView.addSubview(backView1)
            
            _ = backView1.anchor(searchView.topAnchor, left: searchView.rightAnchor, bottom: searchView.bottomAnchor, right: searchView.rightAnchor, topConstant: 0, leftConstant: -60, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
            let backView2 = UIView()
            backView2.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            searchView.addSubview(backView2)
            
            _ = backView2.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: searchView.bottomAnchor, right: searchView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 60, widthConstant: 0, heightConstant: 0)
            
            let gradientMask = CAGradientLayer()
            
            gradientMask.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
            gradientMask.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            gradientMask.startPoint = CGPoint(x: 0.5, y: 0.5);
            gradientMask.endPoint = CGPoint(x: 0.0, y: 0.5);
            
            let maskView: UIView = UIView()
            maskView.layer.addSublayer(gradientMask)
            
            backView2.mask = maskView
            
            searchView1 = backView1
            searchView2 = backView2
            
            searchView.addSubview(searchButton)
            searchView.addSubview(searchField)
            
            searchButton.centerXAnchor.constraint(equalTo: searchView.rightAnchor, constant: -30).isActive = true
            searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
            searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            _ = searchField.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: searchView.bottomAnchor, right: searchView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 60 , widthConstant: 0, heightConstant: 0)
            searchField.isHidden = true
        }

    }
    
}
