//
//  CollabRoomViewController.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 27/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

class CollabRoomViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Table view data source
extension CollabRoomViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TopWallCell") as? CollabTopBottomWallCell{
                cell.delegate = self
                return cell
            }
        }else if indexPath.row == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LeftRightWallCell") as? CollabLeftRightWallCell{
                cell.delegate = self
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BottomWallCell") as? CollabTopBottomWallCell{
                cell.delegate = self
                return cell
            }
        }
        // return the default cell if none of above succeed
        return UITableViewCell()
    }
    
}

// MARK: - CellImageTapDelegate
extension CollabRoomViewController: CellImageTapDelegate{
    
    func tableCell(didClickedImageOf tableCell: UITableViewCell) {
        if let rowIndexPath = tableView.indexPath(for: tableCell) {
            print("Row Selected of indexPath: \(rowIndexPath)")
            presentCameraForCaptureWall()
        }
    }
    private func presentCameraForCaptureWall() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.allowsEditing = true
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CollabRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        // print out the image size as a test
        print(image.size)
        self.dismiss(animated: true)
    }
}
