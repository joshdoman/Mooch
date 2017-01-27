//
//  EditPhotoController22.swift
//  Mooch
//
//  Created by Josh Doman on 1/12/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit


class EditPhotoController2: UIViewController {
    
    lazy var capturedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignFirstResponder))
        tapGestureRecognizer.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    let pickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let picker1BackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Cancel")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 5
        button.layer.shouldRasterize = true
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "Select") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Back-arrow-right")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var backButton2: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Back-arrow-left")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.addTarget(self, action: #selector(handleBackFromCategory), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Search")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        button.tintColor = UIColor(r: 240, g: 240, b: 240)
        return button
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.showsSearchResultsButton = false
        sb.barStyle = .blackTranslucent
        return sb
    }()
    
    let descriptionContainerView: DescriptionView = {
        let view = DescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchField: LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGray]
        tf.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
        tf.textColor = UIColor(r: 240, g: 240, b: 240)
        tf.textAlignment = .right
        tf.autocorrectionType = UITextAutocorrectionType.no
        return tf
    }()
    
    var searchView: UIView? = UIView()
    
    var titleLabel: UILabel?
    var titleBackView: UIView?
    var titleBackView2: UIView?
    var searchView1: UIView?
    var searchView2: UIView?
    
    var pickerState: PickerState = .pick
    
    var currentImage: UIImage? {
        didSet {
            capturedImageView.image = currentImage
            movePicker(onScreen: currentImage != nil, label: "Center")
        }
    }
    
    var currentRow: Int?
    
    var currentCategory: Category? {
        didSet {
            subcategories = currentCategory?.getSubcategories()
        }
    }
    
    var subcategories: [Category]? {
        didSet {
            if let subcategories = subcategories {
                categoryPicker.reloadAllComponents()
            }
        }
    }
    
    var supercategory: String?
    
    //var chosenCategory: Category?
    
    var searchCategories: [String]?
    
    var object: Object?
    
    var delegate: PhotoControllerDelegate?
    var timer: Timer?
    
    var labelRightAnchorsDictionary: [String: NSLayoutConstraint] = [String: NSLayoutConstraint]()
    var labelWidthAnchorsDictionary: [String: NSLayoutConstraint] = [String: NSLayoutConstraint]()
    var labelWidthsDictionary: [String: CGFloat] = [String: CGFloat]()
    var labelDictionary: [String: UILabel] = [String: UILabel]()
    
    var categoryLabels: [UILabel] = [UILabel]()
    
    var pickerViewRightAnchor: NSLayoutConstraint?
    var descriptionViewBottomAnchor: NSLayoutConstraint?
    var descriptionViewHeightAnchor: NSLayoutConstraint?
    var backButtonRightAnchor: NSLayoutConstraint?
    var bagButtonLeftAnchor: NSLayoutConstraint?
    var searchViewWidthAnchor: NSLayoutConstraint?
    var mainViewTopAnchor: NSLayoutConstraint?
    var labelHeightAnchor: NSLayoutConstraint?
    
    var labelHeight: CGFloat?
    var startRow: Int?
    var showSearchBar: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
}

extension EditPhotoController2: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let subcategories = subcategories {
            return subcategories.count
        } else {
            return 0
        }
    }
}


extension EditPhotoController2: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if let view = view {
            return view
        }
        
        let myView = UIView()
        
        let myImageView = UIImageView()
        
        if let imageName = subcategories?[row].getImageName() {
            myImageView.image = UIImage(named: imageName)
        }
        
        let size = CGFloat(60)
        
        myView.addSubview(myImageView)
        
        _ = myImageView.anchor(nil, left: nil, bottom: nil, right: myView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: size, heightConstant: size)
        myImageView.centerYAnchor.constraint(equalTo: myView.centerYAnchor).isActive = true
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row
    }
}

extension EditPhotoController2: DescriptionViewDelegate {
    
    func handleKeyboardShow(notification: NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height
            descriptionViewBottomAnchor?.constant = -keyboardHeight
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    func handleKeyboardHide() {
        descriptionViewBottomAnchor?.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func expandDescriptionView(height: CGFloat) {
        descriptionViewHeightAnchor?.constant = height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func handleDone() {
        placeObjectInBag()
        handleCancel()
    }
}

extension EditPhotoController2: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension EditPhotoController2: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
//        if textField == searchField {
//            moveSearchField(onScreen: false)
//        }
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let txt = textField.text {
//            if let category = self.superCategory {
//                if let superCategoryNotString = Model.CategoryDictionary[category] {
//                    timer?.invalidate()
//                    timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
//                        
//                        let str = txt as NSString
//                        let text = str.replacingCharacters(in: range, with: string)
//                        
//                        if text.isEmpty {
//                            self.categories = superCategoryNotString.getSubcategoryNames()
//                        } else {
//                            let allSubcategories = Model.GetAllSubCategories(category: superCategoryNotString)
//                            var searchResults = allSubcategories.filter({(coisas:Category) -> Bool in
//                                let stringMatch = coisas.getName().lowercased().range(of: text.lowercased())
//                                return stringMatch != nil
//                            })
//                            
//                            //most prevalent results are last in array
//                            searchResults.sort(by: { (ctg1, ctg2) -> Bool in
//                                let str1 = ctg1.getName()
//                                let str2 = ctg2.getName()
//                                if let range1 = str1.lowercased().range(of: text.lowercased()), let range2 = str2.lowercased().range(of: text.lowercased()) {
//                                    return str1.distance(from: str1.startIndex, to: range1.lowerBound) > str2.distance(from: str2.startIndex, to: range2.lowerBound)
//                                }
//                                return true
//                            })
//                            
//                            var searchResultsNames: [String] = [String]()
//                            for category in searchResults {
//                                searchResultsNames.append(category.getName())
//                            }
//                            self.categories = searchResultsNames
//                        }
//                    })
//                }
//            }
//            
//        }
//        return true
//    }
//    
}
