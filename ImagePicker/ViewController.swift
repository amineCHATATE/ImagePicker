//
//  ViewController.swift
//  ImagePicker
//
//  Created by Amine CHATATE on 11/21/18.
//  Copyright © 2018 Amine CHATATE. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.layer.cornerRadius = 10
        self.imagePicker.delegate = self
    }

    @IBAction func tackePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController.init(title: "Error", message: "Your phone dosn't have any camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status{
                case .authorized:
                    self.presentPhotoPickerController()
                case .notDetermined:
                    self.notDeterminedAccess(status)
                case .restricted:
                    self.restrictedAccess()
                case .denied:
                    self.deniedAccess()
                default :
                    break
                }
            })
        }
    }
    
    fileprivate func presentPhotoPickerController() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func notDeterminedAccess(_ status: (PHAuthorizationStatus)) {
        if status == PHAuthorizationStatus.authorized{
            self.presentPhotoPickerController()
        }
    }
    
    fileprivate func restrictedAccess() {
        let alert = UIAlertController(title: "Photo Library Restriction", message: "Photo library access is restricted and cannot be accessed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func deniedAccess() {
        let alert = UIAlertController(title: "Photo Library Access Denied", message: "You have to go to Settings to change it.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Sittings", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
