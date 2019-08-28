//
//  CroppableView.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 20/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

final class CroppableView {
    
    //Corner sphere
    fileprivate var topLeft : SCNSphere?
    fileprivate var topRight : SCNSphere?
    fileprivate var bottomLeft : SCNSphere?
    fileprivate var bottomRight : SCNSphere?
    
    //Nodes for all corners
     var topLeftNode: SCNNode!
     var topRightNode: SCNNode!
     var bottomLeftNode: SCNNode!
     var bottomRightNode: SCNNode!
    
    //Text for all sides
    fileprivate var toptext : SCNText!
    fileprivate var lefttext : SCNText!
    fileprivate var bottomtext : SCNText!
    fileprivate var righttext : SCNText!
    
    //Nodes for text
    fileprivate var toptextNode: SCNNode!
    fileprivate var lefttextNode: SCNNode!
    fileprivate var bottomtextNode: SCNNode!
    fileprivate var righttextNode: SCNNode!
    
    //Nodes for Lines
    fileprivate var toplineNode: SCNNode?
    fileprivate var leftlineNode: SCNNode?
    fileprivate var bottomlineNode: SCNNode?
    fileprivate var rightlineNode: SCNNode?

    
    fileprivate let sceneView: ARSCNView!
    fileprivate var startVector: SCNVector3!
    
    
    let unit: DistanceUnit!
    var lineType: LineType = .none
    
    var cornerpoints =  [SCNNode]()

    
    init(sceneView: ARSCNView, startVector: SCNVector3, unit: DistanceUnit) {
        
        self.sceneView = sceneView
        self.startVector = startVector
        self.unit = unit
        
        //intiate all corner points
        intiateAllCorners()
        
        self.startVector = startVector
        
        //setting postion of top Left Node i.e end point
        topLeftNode = SCNNode(geometry: topLeft)
        topLeftNode.name = "topLeftNode"
        topLeftNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
         //top Right Node
        topRightNode = SCNNode(geometry: topRight)
        topRightNode.name = "topRightNode"
        topRightNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
         //Bottom Left Node
        bottomLeftNode = SCNNode(geometry: bottomLeft)
        bottomLeftNode.name = "bottomLeftNode"
        bottomLeftNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        //Bottom Right Node
        bottomRightNode = SCNNode(geometry: bottomRight)
        bottomRightNode.name = "bottomRightNode"
        bottomRightNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        
        //Create top Text Node and add on sceneView
        toptextNode = SCNNode()
        toptextNode.addChildNode(createTextWrapperNode(with: toptext))
        toptextNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(toptextNode)
        
        //Create left Text Node and add on sceneView
        lefttextNode = SCNNode()
        lefttextNode.addChildNode(createTextWrapperNode(with: lefttext))
        lefttextNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(lefttextNode)
        
        //Create bottom Text Node and add on sceneView
        bottomtextNode = SCNNode()
        bottomtextNode.addChildNode(createTextWrapperNode(with: bottomtext))
        bottomtextNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(bottomtextNode)
        
        //Create right Text Node and add on sceneView
        righttextNode = SCNNode()
        righttextNode.addChildNode(createTextWrapperNode(with: righttext))
        righttextNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(righttextNode)
    }
    
    func update(to vector: SCNVector3,with nearNode:SCNNode?) {
        if let nearnode = nearNode{
            findNearNode(endPoint: vector, with: nearnode)
        }else{
            drawRectWithStartAndEnd(startVector, endPoint: vector)
        }
    }
    
    func findNearNode(endPoint: SCNVector3,with nearNode:SCNNode) {
        switch nearNode.name {
        case "topLeftNode":
            self.startVector = bottomRightNode.position
            topLeftNode.position = endPoint
            topRightNode.position = SCNVector3(self.startVector.x, endPoint.y, self.startVector.z)
            bottomLeftNode.position = SCNVector3(endPoint.x, self.startVector.y, endPoint.z)
            updateLineBasedOnCornerPoints()
            
        case "topRightNode":
            self.startVector = bottomLeftNode.position
            topRightNode.position = endPoint
            topLeftNode.position = SCNVector3(self.startVector.x, endPoint.y, self.startVector.z)
            bottomRightNode.position = SCNVector3(endPoint.x, self.startVector.y, endPoint.z)
            updateLineBasedOnCornerPoints()
        case "bottomLeftNode":
            self.startVector = topRightNode.position
            bottomLeftNode.position = endPoint
            topLeftNode.position = SCNVector3(endPoint.x, self.startVector.y, endPoint.z)
            bottomRightNode.position = SCNVector3(self.startVector.x, endPoint.y, self.startVector.z)
            updateLineBasedOnCornerPoints()
        case "bottomRightNode":
            self.startVector = topLeftNode.position
            bottomRightNode.position = endPoint
            topRightNode.position = SCNVector3(endPoint.x, self.startVector.y, endPoint.z)
            bottomLeftNode.position = SCNVector3(self.startVector.x, endPoint.y, self.startVector.z)
            updateLineBasedOnCornerPoints()
        default:
            print("default")
        }
    }
    
    
    //---------------------------------------------------------------------------------------------------------
    func drawRectWithStartAndEnd(_ startPoint:SCNVector3, endPoint: SCNVector3)
    {
        //setting postion of topleftNode i.e end point
        topLeftNode.position = startPoint
        
        //setting postion of bottomRightNode i.e end point
        bottomRightNode.position = endPoint
        
        //Setting position of another two corners
        topRightNode.position = SCNVector3(endPoint.x, startPoint.y, endPoint.z)
        bottomLeftNode.position = SCNVector3(startPoint.x, endPoint.y, startPoint.z)
        
        if topLeftNode.parent == nil && topRightNode.parent == nil &&  bottomLeftNode.parent == nil && bottomRightNode.parent == nil{
            sceneView.scene.rootNode.addChildNode(topLeftNode)
            sceneView.scene.rootNode.addChildNode(bottomRightNode)
            sceneView.scene.rootNode.addChildNode(topRightNode)
            sceneView.scene.rootNode.addChildNode(bottomLeftNode)
            cornerpoints.append(topLeftNode)
            cornerpoints.append(topRightNode)
            cornerpoints.append(bottomRightNode)
            cornerpoints.append(bottomLeftNode)
        }
        
       updateLineBasedOnCornerPoints()
    }

    func removeFromParentNode() {
        // Clear all the nodes
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
}

// MARK: - Privates
extension CroppableView {
    fileprivate func intiateAllCorners(){
        //Corners Points
        topLeft = createCornerPoints()
        topRight = createCornerPoints()
        bottomLeft = createCornerPoints()
        bottomRight = createCornerPoints()
       
        //SCNText for display distance
        toptext = createSCNTextForDistanceDisplay()
        righttext = createSCNTextForDistanceDisplay()
        bottomtext = createSCNTextForDistanceDisplay()
        lefttext = createSCNTextForDistanceDisplay()
    }
    
    //create corner points
    private func createCornerPoints() -> SCNSphere{
       let sphere =  SCNSphere(radius: 3.5)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        sphere.firstMaterial?.lightingModel = .constant
        sphere.firstMaterial?.isDoubleSided = true
         return sphere
    }
    
    //Create SCNText for display distance
    private func createSCNTextForDistanceDisplay() -> SCNText{
        let text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 15)
        text.firstMaterial?.diffuse.contents = UIColor.white
        text.alignmentMode  = convertFromCATextLayerAlignmentMode(CATextLayerAlignmentMode.center)
        text.truncationMode = convertFromCATextLayerTruncationMode(CATextLayerTruncationMode.middle)
        text.firstMaterial?.isDoubleSided = true
        return text
        
    }
    
    private func createTextWrapperNode(with text:SCNText) -> SCNNode{
        let textWrapperNode = SCNNode(geometry: text)
        textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0)
        textWrapperNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        return textWrapperNode
    }
    
    //Calculate distance from start point to end point
    private func distance(From startVector: SCNVector3, endVector: SCNVector3) -> String {
        return String(format: "%.2f%@", startVector.distance(from: endVector) * unit.fator, unit.unit)
    }
    
    fileprivate func updateLineBasedOnCornerPoints() {
        
        toplineNode?.removeFromParentNode()
        toplineNode = topLeftNode.position.line(to: topRightNode.position, color: .white)
        sceneView.scene.rootNode.addChildNode(toplineNode!)
        toptextNode.position = SCNVector3((topLeftNode.position.x+topRightNode.position.x)/2.0, (topLeftNode.position.y+topRightNode.position.y)/2.0, (topLeftNode.position.z+topRightNode.position.z)/2.0)
        toptext.string = distance(From: topLeftNode.position, endVector: topRightNode.position)
        
        
        leftlineNode?.removeFromParentNode()
        leftlineNode = topLeftNode.position.line(to: bottomLeftNode.position, color: .white)
        sceneView.scene.rootNode.addChildNode(leftlineNode!)
        lefttextNode.position = SCNVector3((topLeftNode.position.x+bottomLeftNode.position.x)/2.0, (topLeftNode.position.y+bottomLeftNode.position.y)/2.0, (topLeftNode.position.z+bottomLeftNode.position.z)/2.0)
        lefttext.string = distance(From: topLeftNode.position, endVector: bottomLeftNode.position)
        
        bottomlineNode?.removeFromParentNode()
        bottomlineNode = bottomLeftNode.position.line(to: bottomRightNode.position, color: .white)
        sceneView.scene.rootNode.addChildNode(bottomlineNode!)
        bottomtextNode.position = SCNVector3((bottomLeftNode.position.x+bottomRightNode.position.x)/2.0, (bottomLeftNode.position.y+bottomRightNode.position.y)/2.0, (bottomLeftNode.position.z+bottomRightNode.position.z)/2.0)
        bottomtext.string = distance(From: bottomLeftNode.position, endVector: bottomRightNode.position)
        
        rightlineNode?.removeFromParentNode()
        rightlineNode = topRightNode.position.line(to: bottomRightNode.position, color: .white)
        sceneView.scene.rootNode.addChildNode(rightlineNode!)
        righttextNode.position = SCNVector3((topRightNode.position.x+bottomRightNode.position.x)/2.0, (topRightNode.position.y+bottomRightNode.position.y)/2.0, (topRightNode.position.z+bottomRightNode.position.z)/2.0)
        righttext.string = distance(From: topRightNode.position, endVector: bottomRightNode.position)
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
