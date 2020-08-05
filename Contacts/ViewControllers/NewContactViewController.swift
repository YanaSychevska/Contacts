//
//  NewContactViewController.swift
//  Contacts
//
//  Created by Yana on 16.07.2020.
//  Copyright © 2020 YanaInc. All rights reserved.
//

import UIKit

class NewContactViewController: UITableViewController {
    
    var newContact = Contact()
    var imageIsChanged = false
    var currentContact: Contact?
    
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactPhoneNumber: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear stripes under textfields
        tableView.tableFooterView = UIView()
        
        //Creation round photo displaying
        contactPhoto.layer.cornerRadius = contactPhoto.frame.width/2
        contactPhoto.clipsToBounds = true
        
        // Enable save button without require textfields
        saveButton.isEnabled = false
        
        // Checkind completing required textfields
        contactName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        contactPhoneNumber.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // TODO: -Add custom image to the detail screen
        
        contactName.text = currentContact?.name
        contactPhoneNumber.text = currentContact?.phoneNumber
        contactEmail.text = currentContact?.email
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func saveNewContact() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = contactPhoto.image
        } else {
            image = UIImage(systemName: "person.circle.fill")?.withTintColor(UIColor(red: CGFloat(174)/CGFloat(255), green: CGFloat(187)/CGFloat(255), blue: CGFloat(227)/CGFloat(255), alpha: 1.0))
        }
        
        let imageData = image?.pngData()
        
        let newContact = Contact(name: contactName.text!, phoneNumber: contactPhoneNumber.text!, email: contactEmail.text!, imageData: imageData)
        
        StorageManager.saveObject(newContact)
    }
    
    // Choosing method of adding new photo
    @IBAction func addNewPhoto(_ sender: UIButton) {
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}

// MARK: -Work with image
extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        contactPhoto.image = info[.editedImage] as? UIImage
        contactPhoto.contentMode = .scaleAspectFill
        contactPhoto.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}

// MARK: -Text field delegate
extension NewContactViewController: UITextFieldDelegate{
    
    // Hiding keyboard to tap on button Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if contactName.text?.isEmpty == false && contactPhoneNumber.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
