//
//  CollabRoomViewModel.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 28/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation
import UIKit

protocol RoomViewModelDelegate: class {
    func reloadTable()
    func roomMeasurecompleted()
}

class CollabRoomViewModel: NSObject {
    
    var room:CollabRoomModel?
    
    weak var delegate: RoomViewModelDelegate?
    
    override init() {
        room = CollabRoomModel()
    }
    
     func updateWallinRoom(wallImg:UIImage?, wallHeight:String?, wallWidth:String?, wallType:WallType) {
        switch wallType {
        case .top:
            room?.topWall = prepareWall(wallImg: wallImg, wallHeight: wallHeight, wallWidth: wallWidth, wallType: wallType)
        case .bottom:
            room?.bottomtWall = prepareWall(wallImg: wallImg, wallHeight: wallHeight, wallWidth: wallWidth, wallType: wallType)
        case .left:
            room?.leftWall = prepareWall(wallImg: wallImg, wallHeight: wallHeight, wallWidth: wallWidth, wallType: wallType)
        case .right:
            room?.rightWall = prepareWall(wallImg: wallImg, wallHeight: wallHeight, wallWidth: wallWidth, wallType: wallType)
        default:
            print("none")
        }
        self.delegate?.reloadTable()
        
        if let _ = room?.topWall, let _ = room?.bottomtWall, let _ = room?.leftWall, let _ = room?.rightWall{
            isRoomComplted()
        }

    }
    
    private func prepareWall(wallImg:UIImage?, wallHeight:String?, wallWidth:String?, wallType:WallType) -> CollabWallModel?{
        let wall = CollabWallModel()
        wall.wallImage = wallImg
        wall.wallHeight = wallHeight
        wall.wallWidth = wallWidth
        wall.wallType = .top
        return wall
    }
    
    private func isRoomComplted() {
        self.delegate?.roomMeasurecompleted()
    }
    
    
//    func updateRoom(wall:CollabWallModel) {
//        switch wall.wallType {
//        case WallType.top:
//            room?.topWall = wall
//
//        case WallType.bottom:
//            room?.bottomtWall = wall
//        case WallType.left:
//            room?.leftWall = wall
//        case WallType.right:
//            room?.rightWall = wall
//        default:
//            room?.topWall = wall
//        }
//    }
}
