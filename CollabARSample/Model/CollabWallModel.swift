//
//  CollabWallModel.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 28/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation
import UIKit

enum WallType{
    case none
    case top
    case bottom
    case left
    case right
    
    var title: String {
        switch self {
        case .top:
            return "Top Wall"
        case .bottom:
            return "Bottom Wall"
        case .left:
            return "Left Wall"
        case .right:
            return "Right Wall"
        case .none:
            return "none"
        }
    }
}

class CollabWallModel {
    var wallType:WallType = .none
    var wallImage: UIImage?
    var wallHeight: String?
    var wallWidth: String?
    var walllenuength: String?
}
