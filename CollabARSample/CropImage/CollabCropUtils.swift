//
//  CollabCropUtils.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 14/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation

/// Function to execute a block after a delay.
/// - parameter delay:: Double delay in seconds

func delay(_ delay: Double, block:@escaping ()->())
{
    let nSecDispatchTime = DispatchTime.now() + delay;
    let queue = DispatchQueue.main
    
    queue.asyncAfter(deadline: nSecDispatchTime, execute: block)
}
