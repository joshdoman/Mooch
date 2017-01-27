//
//  DescriptionView.swift
//  Mooch
//
//  Created by Josh Doman on 1/8/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import AudioToolbox

class DescriptionView: UIView, UITextViewDelegate {

    var category: String? {
        didSet {
            if let category = category {
                categoryImage.image = UIImage(named: category)
            } else {
                categoryImage.image = nil
            }
        }
    }
    
    let categoryImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGray]
        textField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: attributes)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.textColor = .white
        return textField
    }()
    
    let descriptionPlaceholder = "Add a description here..."
    
    let descriptionTextBox: UITextView = {
        let text = UITextView()
        text.textColor = .lightGray
        text.autocorrectionType = UITextAutocorrectionType.no
        text.font = UIFont(name: "Helvetica", size: 18)
        text.backgroundColor = .clear
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "Send") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        //button.tintColor = UIColor(r: 0, g: 122, b: 255)
        return button
    }()
    
    var delegate: DescriptionViewDelegate?
    var height: CGFloat = 150 {
        didSet {
            delegate?.expandDescriptionView(height: height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
        
    func setupViews() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        addSubview(categoryImage)
        addSubview(titleField)
        addSubview(descriptionTextBox)
        addSubview(sendButton)
        
        _ = categoryImage.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        
        _ = titleField.anchor(nil, left: categoryImage.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 44)
        titleField.centerYAnchor.constraint(equalTo: categoryImage.centerYAnchor).isActive = true
        
        _ = sendButton.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 8, widthConstant: 60, heightConstant: 60)
        
        _ = descriptionTextBox.anchor(categoryImage.bottomAnchor, left: categoryImage.leftAnchor, bottom: bottomAnchor, right: sendButton.leftAnchor, topConstant: 16, leftConstant: 4, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        descriptionTextBox.delegate = self
        descriptionTextBox.text = descriptionPlaceholder
        
        observeKeyboardNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil) //keyboard pops up when click in text field
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil) //keyboard pops up when click in text field
    }
    
    func keyboardShow(notification: NSNotification) {
        delegate?.handleKeyboardShow(notification: notification)
    }
    
    func keyboardHide() {
        delegate?.handleKeyboardHide()

    }
    
    func present() {
        titleField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        titleField.resignFirstResponder()
        descriptionTextBox.resignFirstResponder()
        return true
    }
    
    func reset() {
        category = nil
        _ = resignFirstResponder()
        titleField.text = nil
        descriptionTextBox.text = descriptionPlaceholder
        descriptionTextBox.textColor = .lightGray
        prevLineNumber = 1
        height = 150
    }
    
    func setupForObject(object: Object) {
        descriptionTextBox.removeFromSuperview()
        
        titleField.text = object.title
        titleField.textColor = .white
        titleField.isUserInteractionEnabled = false
        category = object.categoryPath?.last
        sendButton.isHidden = true
        if let keyWindow = UIApplication.shared.keyWindow, let text = object.descriptor,
            let font = descriptionTextBox.font {
            descriptionTextBox.text = text
            descriptionTextBox.textColor = .white
            descriptionTextBox.isUserInteractionEnabled = false
            
            addSubview(descriptionTextBox)
            
            let textWidth = keyWindow.frame.width - 98
            
//            var textWidth = UIEdgeInsetsInsetRect(descriptionTextBox.frame, descriptionTextBox.textContainerInset).width
//            textWidth -= 2.0 * descriptionTextBox.textContainer.lineFragmentPadding;
            
            let boundingRect = sizeOfString(string: text, constrainedToWidth: Double(textWidth), font: font)
            let numberOfLines = boundingRect.height / font.lineHeight
            height = (numberOfLines - 1) * font.lineHeight + 150
            
            _ = descriptionTextBox.anchor(categoryImage.bottomAnchor, left: categoryImage.leftAnchor, bottom: bottomAnchor, right: sendButton.leftAnchor, topConstant: 16, leftConstant: 4, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        } else {
            height = 92
        }
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.text = descriptionPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceholder
            textView.textColor = .lightGray
            textView.selectedRange = NSMakeRange(0, 0)
        } else if textView.textColor == .lightGray {
            if let str = textView.text {
                let index = str.index(str.startIndex, offsetBy: 1)
                textView.text = str.substring(to: index)
                textView.textColor = .white
            }
        }
    }
    
    var prevLineNumber: CGFloat = 1
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        var textWidth = UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).width
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
        let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight
        if numberOfLines <= 4 && numberOfLines != prevLineNumber, let font = textView.font {
            let change = numberOfLines > prevLineNumber ? font.lineHeight : -font.lineHeight
            height += change
            prevLineNumber = numberOfLines
        }
        
        return numberOfLines <= 2;
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
    }
    
    func handleSend() {
        if titleField.text == nil || titleField.text == "" {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: titleField.center.x - 5, y: titleField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: titleField.center.x + 5, y: titleField.center.y))
            titleField.layer.add(animation, forKey: "position")
        } else {
            delegate?.handleDone()
        }
    }
}
