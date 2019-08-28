//
//  ARSCNView.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 03/07/19.
//  Copyright © 2019 Wipro. All rights reserved.
//
//

import SceneKit
import ARKit

extension ARSCNView {
    func realWorldVector(screenPosition: CGPoint) -> SCNVector3? {
        let results = self.hitTest(screenPosition, types: [.estimatedVerticalPlane,.featurePoint])
        guard let result = results.first else { return nil }
        return SCNVector3.positionFromTransform(result.worldTransform)
    }
}
