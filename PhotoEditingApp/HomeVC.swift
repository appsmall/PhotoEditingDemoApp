//
//  HomeVC.swift
//  PhotoEditingApp
//
//  Created by Rahul Chopra on 19/10/18.
//  Copyright © 2018 Rahul Chopra. All rights reserved.
//

import UIKit
import Photos

class HomeVC: UIViewController {
    
    struct Storyboard {
        static let homeVCToSelectedPhotoVC = "homeVCToSelectedPhotoVC"
    }
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var listView: UIImageView!
    
    var allPhotos : PHFetchResult<PHAsset>? = nil
    var isListView: Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        accessPhotoLibraryAuthorization()
    }
    
    func accessPhotoLibraryAuthorization() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized :
                print("Authorized")
                let fetchOptions = PHFetchOptions()
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                print("Found \(self.allPhotos!.count) assets")
                DispatchQueue.main.async {
                    self.photosCollectionView.reloadData()
                }
                
            case .denied:
                print("Denied")
                
            case .notDetermined:
                print("Not Determined")
                
            case .restricted:
                print("Restricted")
            }
        }
    }
    
    func fetchImageSize(asset: PHAsset, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            guard let image = image else { return }
            print("Image Size: \(image.size)")
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func listViewTapped(_ sender: UITapGestureRecognizer) {
        if isListView {
            // Set List View to Grid View
            self.listView.image = UIImage(named: "ic_list_view")
            isListView = false
        }
        else {
            // Set Grid View to List View
            self.listView.image = UIImage(named: "ic_grid_view")
            isListView = true
        }
        
        self.photosCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.homeVCToSelectedPhotoVC {
            if let destination = segue.destination as? SelectedPhotoVC {
                if let selectedIndexPath = photosCollectionView.indexPathsForSelectedItems?.first {
                    destination.selectedImage = allPhotos![selectedIndexPath.row]
                }
            }
        }
    }
    
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allPhotos = allPhotos {
            return allPhotos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCell
        
        if let asset = allPhotos?.object(at: indexPath.row) {
            cell.photoImageView.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: cell.photoImageView.frame.size)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.homeVCToSelectedPhotoVC, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = self.view.frame.size.width
        
        if isListView {
            // List View
            if let asset = allPhotos?.object(at: indexPath.row) {
               fetchImageSize(asset: asset, targetSize: CGSize(width: 100, height: 100))
                
                return CGSize(width: viewWidth, height: 200)
            }
            return CGSize(width: viewWidth, height: 200)
        } else {
            // Grid View
            let width = viewWidth / 4.5
            return CGSize(width: width, height: width)
        }
    }
}


extension UIImageView{
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            }
            self.image = image
        }
    }
}

