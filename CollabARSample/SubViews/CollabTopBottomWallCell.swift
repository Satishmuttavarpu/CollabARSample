//
//  CollabTopBottomWallCell.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 28/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit

protocol CellImageTapDelegate {
    func tableCell(didClickedImageOf tableCell: UITableViewCell)
}

class CollabTopBottomWallCell: UITableViewCell {

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
        initialize()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initialize() {
        tapGestureRecognizer.addTarget(self, action: #selector(CollabTopBottomWallCell.imageTapped(gestureRecgonizer:)))
        wallImg.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(gestureRecgonizer: UITapGestureRecognizer) {
        delegate?.tableCell(didClickedImageOf: self)

    }

}
