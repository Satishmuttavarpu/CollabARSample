//
//  CollabTopBottomWallCell.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 28/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

protocol CellImageTapDelegate {
    func tableCell(didClickedImageOf tableCell: UITableViewCell, wallType:WallType)
}

class CollabTopBottomWallCell: UITableViewCell, UITextFieldDelegate  {

    @IBOutlet weak var wallImg:UIImageView!
    @IBOutlet weak var wallWidthLine:UILabel!
    @IBOutlet weak var wallHeightLine:UILabel!
    @IBOutlet weak var wallWidthTextFeild:UITextField!
    @IBOutlet weak var wallHeightTextFeild:UITextField!

    var delegate : CellImageTapDelegate?
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        wallWidthTextFeild.delegate = self
        wallHeightTextFeild.delegate = self
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initialize() {
        tapGestureRecognizer.addTarget(self, action: #selector(CollabTopBottomWallCell.imageTapped(gestureRecgonizer:)))
        wallImg.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureWall(wallViewModel wall:CollabWallModel) {
        self.wallImg.image = wall.wallImage
        self.wallWidthTextFeild.text = wall.wallWidth
        self.wallHeightTextFeild.text = wall.wallHeight
    }
    
    @objc func imageTapped(gestureRecgonizer: UITapGestureRecognizer) {
        if self.reuseIdentifier == "TopWallCell"{
            delegate?.tableCell(didClickedImageOf: self, wallType: WallType.top)
        }else{
            delegate?.tableCell(didClickedImageOf: self, wallType: WallType.bottom)
        }
    }
    
      // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textFeild: UITextField) -> Bool {
        textFeild.resignFirstResponder()
        return true
    }
}
