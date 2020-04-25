//
//  SelectedPhotoVC.swift
//  PhotoEditingApp
//
//  Created by Rahul Chopra on 19/10/18.
//  Copyright © 2018 Rahul Chopra. All rights reserved.
//

import UIKit
import Photos

class SelectedPhotoVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage : PHAsset?
    
    var toolNameArray = ["Crop", "Effects", "", ""]
    var toolImageArray = ["ic_crop", "ic_effects", "", ""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        // this one is key
        requestOptions.isSynchronous = true
        
        if (selectedImage!.mediaType == .image)
        {
            PHImageManager.default().requestImage(for: selectedImage!, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions, resultHandler: { (pickedImage, info) in
                
                self.imageView.image = pickedImage
            })
            
        }
        
    }
    
    // MARK:- IBACTIONS
    @IBAction func backButtonPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension SelectedPhotoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolCell", for: indexPath) as! ToolCell
        
        cell.imageView.image = UIImage(named: toolImageArray[indexPath.row])
        cell.toolLabel.text = toolNameArray[indexPath.row]
        
        return cell
    }
}
