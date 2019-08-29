//
//  CollabRoomViewController.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 27/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

class CollabRoomViewController: UITableViewController {
    
    fileprivate let viewModel : CollabRoomViewModel = CollabRoomViewModel()
    fileprivate var roomWallType:WallType = .none
    fileprivate lazy var myPickerController = UIImagePickerController()
    fileprivate lazy var selectedIndexPath:IndexPath = IndexPath(row: 0, section: 0)

    fileprivate lazy var doneButton : UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        return btn
    }()
    
    fileprivate lazy var cancelButton : UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.title = "Measure Room"
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = cancelButton

    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        CollabAlertView.showAlertWithHandler(title: "Room Measurement", message: "Room Measurement sent sucessfully", topViewcontroller: self) { [weak self] (index) in
            guard let weakSelf = self else { return }
            weakSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        CollabAlertView.showAlertWithHandler(title: "Room Measurement", message: "May be measurements will lost if you go back", okButtonTitle: "Go Back", cancelButtionTitle: "Cancel", topViewcontroller: self) { [weak self] (action) in
            guard let weakSelf = self else { return }
            if action == AlertAction.Ok{
                weakSelf.dismiss(animated: true, completion: nil)
            }
        }
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
                if let wall = viewModel.room?.topWall{
                    cell.configureWall(wallViewModel: wall)
                }
                return cell
            }
        }else if indexPath.row == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LeftRightWallCell") as? CollabLeftRightWallCell{
                cell.delegate = self
                if roomWallType == .left{
                    if let wall = viewModel.room?.leftWall{
                        cell.configureLeftWall(wallViewModel: wall)
                    }
                    if let wall = viewModel.room?.rightWall{
                        cell.configureRightWall(wallViewModel: wall)
                    }
                    
                }else if roomWallType == .right{
                    if let wall = viewModel.room?.rightWall{
                        cell.configureRightWall(wallViewModel: wall)
                    }
                    if let wall = viewModel.room?.leftWall{
                        cell.configureLeftWall(wallViewModel: wall)
                    }
                }
                
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BottomWallCell") as? CollabTopBottomWallCell{
                cell.delegate = self
                if let wall = viewModel.room?.bottomtWall{
                    cell.configureWall(wallViewModel: wall)
                }
                return cell
            }
        }
        // return the default cell if none of above succeed
        return UITableViewCell()
    }
    
}

// MARK: - CellImageTapDelegate
extension CollabRoomViewController: CellImageTapDelegate, RoomViewModelDelegate{
    func tableCell(didClickedImageOf tableCell: UITableViewCell, wallType: WallType) {
        if let rowIndexPath = tableView.indexPath(for: tableCell) {
            selectedIndexPath = rowIndexPath
            roomWallType = wallType
            presentCameraForCaptureWall()
        }
    }
    
    private func presentCameraForCaptureWall() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myPickerController.allowsEditing = true
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: - RoomViewModelDelegate
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
             weakSelf.tableView.beginUpdates()
             weakSelf.tableView.reloadRows(at: [weakSelf.selectedIndexPath], with: .fade) //try other animations
             weakSelf.tableView.endUpdates()
        }
    }
    
    func roomMeasurecompleted(){
         self.navigationItem.rightBarButtonItem = doneButton
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
        showAlertForHeightAndWidth(wallImg: image)
    }
    
    private func showAlertForHeightAndWidth(wallImg:UIImage) {
        CollabAlertView.showAlertForHeightAndWidth(title: roomWallType.title, message: "Enter Height and Width", topViewcontroller:myPickerController) { [weak self] (height,width) in
            guard let weakSelf = self else { return }
            weakSelf.dismiss(animated: true)
            //Update Room after Measure Wall
            weakSelf.updateRoom(wallImg, height, width)
        }
    }
    
    private func updateRoom(_ img:UIImage,_ height:String?,_ width:String?) {
        //Update Room  Model after Measure Wall
        viewModel.updateWallinRoom(wallImg: img, wallHeight: height, wallWidth: width, wallType: roomWallType)
    }
    
}
