//
//  CollabLeftRightWallCell.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 28/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

class CollabLeftRightWallCell: UITableViewCell {

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
        // Initialization code
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initialize() {
        lefttapGestureRecognizer.addTarget(self, action: #selector(CollabTopBottomWallCell.imageTapped(gestureRecgonizer:)))
        RighttapGestureRecognizer.addTarget(self, action: #selector(CollabTopBottomWallCell.imageTapped(gestureRecgonizer:)))

        leftWallImg.addGestureRecognizer(lefttapGestureRecognizer)
        rightWallImg.addGestureRecognizer(RighttapGestureRecognizer)
    }
    
    @objc func imageTapped(gestureRecgonizer: UITapGestureRecognizer) {
        delegate?.tableCell(didClickedImageOf: self)
    }

}
