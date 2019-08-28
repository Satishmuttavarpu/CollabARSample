//
//  CollabCornerClientProtocol.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 14/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation

@objc protocol CollabCornerClientProtocol
{
    func cornerHasChanged(_: CollabCornerPointView)
}
