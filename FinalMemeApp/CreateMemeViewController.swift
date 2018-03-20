//
//  CreateMemeViewController.swift
//  FinalMemeApp
//
//  Created by Mochammad Alamsyah on 19/03/18.
//  Copyright © 2018 malamsyah.id. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var cameraButton = UIBarButtonItem()
    var albumButton = UIBarButtonItem()
    var space = UIBarButtonItem()
    var shareButton = UIBarButtonItem()
    var cancelButton = UIBarButtonItem()
    var keyboardIsHidden = true
    
    var currentMeme:Meme!
    var generatedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTextField(text: "TOP", textField: topTextField)
        configTextField(text: "BOTTOM", textField: bottomTextField)
        
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(CreateMemeViewController.share))
        cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action:#selector(CreateMemeViewController.cancelButtonAction))
        cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action:#selector(CreateMemeViewController.getImageFromCamera(_:)))
        albumButton = UIBarButtonItem(title: "Album", style: .done, target: self, action:#selector(CreateMemeViewController.getImageFromAlbum(_:)))
        space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = cancelButton
        self.navigationItem.leftBarButtonItem = shareButton
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if(memeImageView.image == nil){
            self.shareButton.isEnabled = false
        }else{
            self.shareButton.isEnabled = true
        }
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.toolbarItems = [space, cameraButton, space, albumButton, space]
    }
    
    @objc func cancelButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configTextField(text:String, textField:UITextField) {
        let textStyles = [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.font.rawValue : UIFont(name: "impact", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue : -3,
            ] as [String : Any]
        
        textField.defaultTextAttributes = textStyles
        textField.textAlignment = .center
        textField.text! = text
        textField.delegate = self
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
        keyboardIsHidden = false
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if(!keyboardIsHidden){
            self.view.frame.origin.y = 0
            keyboardIsHidden = true
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func hide(flag:Bool,animated:Bool){
        self.navigationController?.setNavigationBarHidden(flag, animated: animated)
        self.navigationController?.setToolbarHidden(flag, animated: animated)
    }
    
    func generateMemedImage() -> UIImage {
        hide(flag: true, animated: false)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hide(flag: false, animated: true)
        return memedImage
    }
    
    func save() {
        self.currentMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memeImage: generatedImage)
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        applicationDelegate.memes.append(self.currentMeme)
        applicationDelegate.currentMeme = Meme(topText: "TOP", bottomText: "BOTTOM", originalImage: UIImage(), memeImage: UIImage())
    }
    
    @objc func share() {
        generatedImage = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)
        activity.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
                self.cancelButtonAction()
            }
        }
        self.present(activity, animated: true, completion:nil)
    }
}

extension CreateMemeViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
        
        if textField.isEqual(bottomTextField) {
            self.subscribeToKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.isEqual(bottomTextField){
            self.unsubscribeFromKeyboardNotifications()
        }
        return true
    }
}

extension  CreateMemeViewController : UIImagePickerControllerDelegate {
    @objc func getImageFromCamera(_: AnyObject) {
        chooseSourceType(sourceType: .camera)
    }
    
    @objc func getImageFromAlbum(_: AnyObject) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(sourceType)){
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
