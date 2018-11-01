//
//  ViewController.swift
//  testTaskArtem
//
//  Created by Артём Нешко on 29/10/2018.
//  Copyright © 2018 Артём Нешко. All rights reserved.
//

import UIKit
import Foundation
import KVNProgress

class AnnotationVC: UIViewController {
    
    @IBOutlet weak var ibPickerButton: UIButton!
    @IBOutlet weak var ibAnnotationsTV: UITableView!
    
    var imagePickerController = UIImagePickerController()
    var annotationsData = [AnnotationLabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.setupImagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ibPickerButton.layer.cornerRadius = 10
    }
    
    //MARK: - Func
    func setupImagePicker() {
        self.imagePickerController.delegate = self
        self.imagePickerController.isEditing = false
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(title: "Нет камеры", message: "В вашем устройстве нет камеры", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        self.imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    func openGallery() {
        self.imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    func laodData(image: UIImage?) {
        if image != nil {
            KVNProgress.show(withStatus: "Загрузка...")
            DataClient.shared.getAnnotations(image: image) { (annotations, error) in
                if annotations != nil {
                    self.annotationsData = annotations!
                    self.ibAnnotationsTV.reloadData()
                    KVNProgress.showSuccess()
                } else {
                    KVNProgress.showError(withStatus: error?.domain)
                }
            }
        } else {
            self.annotationsData = [AnnotationLabel]()
            self.ibAnnotationsTV.reloadData()
            KVNProgress.showError(withStatus: "Не удалось выбрать фото")
        }
    }
    
    //MARK: - @Action
    @IBAction func ibPickerAction(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "Выберете источник", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            print("cancel")
        }
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            print("camra")
            self.openCamera()
        }
        let gallery = UIAlertAction(title: "Галерея", style: .default) { _ in
            self.openGallery()
            print("gallery")
        }
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(camera)
        actionSheetController.addAction(gallery)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

    //MARK: - UITableViewDelegate
extension AnnotationVC: UITableViewDataSource, UITableViewDelegate {
    
    func setupTable() {
        self.ibAnnotationsTV.delegate = self
        self.ibAnnotationsTV.dataSource = self
        self.ibAnnotationsTV.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.annotationsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCell") as? AnnotationTVC else {
            return UITableViewCell()
        }
        cell.setupCell(description: self.annotationsData[indexPath.row].description, score: self.annotationsData[indexPath.row].score)
        return cell
    }
}
    //MARK: - UIImagePickerControllerDelegate
extension AnnotationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = self.extractImage(from: info)
        self.laodData(image: image)
        picker.dismiss(animated: true)
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
}
