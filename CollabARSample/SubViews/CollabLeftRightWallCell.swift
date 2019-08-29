//
//  CollabLeftRightWallCell.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 28/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

class CollabLeftRightWallCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var leftWallImg:UIImageView!
    @IBOutlet weak var leftWallWidthLine:UILabel!
    @IBOutlet weak var leftWallHeightLine:UILabel!
    @IBOutlet weak var leftWallWidthTextFeild:UITextField!
    @IBOutlet weak var leftWallHeightTextFeild:UITextField!
    @IBOutlet weak var rightWallImg:UIImageView!
    @IBOutlet weak var rightWallWidthLine:UILabel!
    @IBOutlet weak var rightWallHeightLine:UILabel!
    @IBOutlet weak var rightWallWidthTextFeild:UITextField!
    @IBOutlet weak var rightWallHeightTextFeild:UITextField!
    
    var lefttapGestureRecognizer = UITapGestureRecognizer()
    var RighttapGestureRecognizer = UITapGestureRecognizer()

    var delegate : CellImageTapDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftWallWidthTextFeild.delegate = self
        leftWallHeightTextFeild.delegate = self
        rightWallWidthTextFeild.delegate = self
        rightWallHeightTextFeild.delegate = self

        // Initialization code
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initialize() {
        lefttapGestureRecognizer.addTarget(self, action: #selector(CollabLeftRightWallCell.leftImageTapped(gestureRecgonizer:)))
        RighttapGestureRecognizer.addTarget(self, action: #selector(CollabLeftRightWallCell.rightImageTapped(gestureRecgonizer:)))

        leftWallImg.addGestureRecognizer(lefttapGestureRecognizer)
        rightWallImg.addGestureRecognizer(RighttapGestureRecognizer)
    }
    
    func configureLeftWall(wallViewModel wall:CollabWallModel) {
        self.leftWallImg.image = wall.wallImage
        self.leftWallWidthTextFeild.text = wall.wallWidth
        self.leftWallHeightTextFeild.text = wall.wallHeight
    }
    
    func configureRightWall(wallViewModel wall:CollabWallModel) {
        self.rightWallImg.image = wall.wallImage
        self.rightWallWidthTextFeild.text = wall.wallWidth
        self.rightWallHeightTextFeild.text = wall.wallHeight
    }
    
    @objc func leftImageTapped(gestureRecgonizer: UITapGestureRecognizer) {
        delegate?.tableCell(didClickedImageOf: self,wallType: WallType.left)
    }
    
    @objc func rightImageTapped(gestureRecgonizer: UITapGestureRecognizer) {
        delegate?.tableCell(didClickedImageOf: self,wallType: WallType.right)
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textFeild: UITextField) -> Bool {
        textFeild.resignFirstResponder()
        return true
    }

}
