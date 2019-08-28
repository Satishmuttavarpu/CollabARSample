//
//  GallaryViewController.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 05/07/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GallaryViewController: UICollectionViewController {

    var images:[UIImage] = []
    
    private lazy var backButton : UIBarButtonItem = {
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backMethod))
        return backBarButtonItem
    }()
    
    private lazy var clearButton : UIBarButtonItem = {
        let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(clearPics))
        return clearBarButtonItem
    }()
    
    
    fileprivate lazy var fileManager = ImagesFileManager.defaultManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = backButton
        
        if let fileImages = fileManager.getImageFromDocumentDirectory(){
            images = fileImages
            if images.count>0{
                self.navigationItem.rightBarButtonItem  = clearButton
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backMethod(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func clearPics(){
        fileManager.clearAllFilesFromDirectory()
        self.refreshTable()
    }
    
    func refreshTable(){
        if let fileImages = fileManager.getImageFromDocumentDirectory(){
            images = fileImages
            if images.count>0 || images.count == 0{
                self.collectionView?.reloadData()
            }
        }        
    }
}

extension GallaryViewController{
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GallaryViewCell
        // Configure the cell
        cell.imgView.image = images[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailImage" {
            let nowDetailView = segue.destination as! ImageDetailViewController
            if ((nowDetailView.view) != nil){
                let cell = sender as! GallaryViewCell
                if let indexPath = self.collectionView?.indexPath(for: cell){
                    let img = images[indexPath.row] as UIImage
                    nowDetailView.detailImgView.image = img
                    //nowDetailView.getImageFromList(image: img)
                }
            }
        }
    }
}
