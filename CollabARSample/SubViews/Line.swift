//
//  Line.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 03/07/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import SceneKit
import ARKit

enum LineType{
    case none
    case topWidth
    case bottomWidth
    case leftHeight
    case rightHeight
    
    var title: String {
        switch self {
        case .topWidth:
            return "Top Width"
        case .bottomWidth:
            return "Bottom Width"
        case .leftHeight:
            return "Left Height"
        case .rightHeight:
            return "Right Height"
        case .none:
            return "none"
        }
    }
    
}

enum DistanceUnit {
    case centimeter
    case inch
    case meter
    
    var fator: Float {
        switch self {
        case .centimeter:
            return 100.0
        case .inch:
            return 39.3700787
        case .meter:
            return 1.0
        }
    }
    
    var unit: String {
        switch self {
        case .centimeter:
            return "cm"
        case .inch:
            return "inch"
        case .meter:
            return "m"
        }
    }
    
    var title: String {
        switch self {
        case .centimeter:
            return "Centimeter"
        case .inch:
            return "Inch"
        case .meter:
            return "Meter"
        }
    }
}

final class Line {
    fileprivate let startDot : SCNSphere = {
        let dotP = SCNSphere(radius: 3.5)
        dotP.firstMaterial?.diffuse.contents = UIColor.red
        dotP.firstMaterial?.lightingModel = .constant
        dotP.firstMaterial?.isDoubleSided = true
        return dotP
    }()
    
    fileprivate let endDot : SCNSphere = {
        let dotP = SCNSphere(radius: 3.5)
        dotP.firstMaterial?.diffuse.contents = UIColor.red
        dotP.firstMaterial?.lightingModel = .constant
        dotP.firstMaterial?.isDoubleSided = true
        return dotP
    }()
    
    fileprivate let text : SCNText = {
        let text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 15)
        text.firstMaterial?.diffuse.contents = UIColor.white
        text.alignmentMode  = convertFromCATextLayerAlignmentMode(CATextLayerAlignmentMode.center)
        text.truncationMode = convertFromCATextLayerTruncationMode(CATextLayerTruncationMode.middle)
        text.firstMaterial?.isDoubleSided = true
        return text
    }()
    
    fileprivate var startNode: SCNNode!
    fileprivate var endNode: SCNNode!
    fileprivate var textNode: SCNNode!
    fileprivate var lineNode: SCNNode?
    fileprivate let sceneView: ARSCNView!
    fileprivate let startVector: SCNVector3!
    let unit: DistanceUnit!
    var lineType: LineType = .none
    var distanceText:String?    

    init(sceneView: ARSCNView, startVector: SCNVector3, unit: DistanceUnit) {
        self.sceneView = sceneView
        self.startVector = startVector
        self.unit = unit
        
        startNode = SCNNode(geometry: startDot)
        startNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        startNode.position = startVector
        sceneView.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: endDot)
        endNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        let textWrapperNode = SCNNode(geometry: text)
        textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0)
        textWrapperNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        textNode = SCNNode()
        textNode.addChildNode(textWrapperNode)
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        textNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    func update(to vector: SCNVector3) {
        lineNode?.removeFromParentNode()
        lineNode = startVector.line(to: vector, color: .white)
        sceneView.scene.rootNode.addChildNode(lineNode!)
        text.string = distance(to: vector)
        textNode.position = SCNVector3((startVector.x+vector.x)/2.0, (startVector.y+vector.y)/2.0, (startVector.z+vector.z)/2.0)
        endNode.position = vector
        if endNode.parent == nil {
            sceneView?.scene.rootNode.addChildNode(endNode)
        }
    }
    
    func updateLineDetails(line:LineType) {
        startNode.name = "StartNode"
        endNode.name = "EndNode"
        lineType = line
        //Update distance
        distanceText = text.string as? String
    }
    
    func distance(to vector: SCNVector3) -> String {
        return String(format: "%.2f%@", startVector.distance(from: vector) * unit.fator, unit.unit)
    }
    
    func removeFromParentNode() {
        startNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATextLayerAlignmentMode(_ input: CATextLayerAlignmentMode) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATextLayerTruncationMode(_ input: CATextLayerTruncationMode) -> String {
	return input.rawValue
}
