//
//  ViewControllerVM.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 07/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ViewControllerVM: NSObject {
    
    var measuring = false
    var indexCount = 0
    var isNearNodeFound = false
    fileprivate lazy var vectorZero = SCNVector3()
    fileprivate lazy var startValue = SCNVector3()
    fileprivate lazy var endValue = SCNVector3()
    fileprivate lazy var nearValue = SCNVector3()
    fileprivate lazy var fileManager = ImagesFileManager.defaultManager
    fileprivate lazy var points2D: [CGPoint] = []
    fileprivate var currentLine: Line?
    fileprivate lazy var unit: DistanceUnit = .meter
    fileprivate var localSceneView:ARSCNView!
    fileprivate lazy var file = ImagesFileManager.defaultManager
    fileprivate lazy var imageViewObject :UIImageView = UIImageView()
    fileprivate var currentbox: CroppableView?
    fileprivate var currentNode:SCNNode?

    
    func startMeasureLine(_ sceneView: ARSCNView,_ worldPosition: SCNVector3){
        localSceneView = sceneView
        if measuring {
            if startValue == vectorZero {
                startValue = isNearNodeFound ? nearValue:worldPosition
                currentbox = CroppableView(sceneView: sceneView, startVector: startValue, unit: unit)
            }
            endValue = isNearNodeFound ? nearValue:worldPosition
            if let box = currentbox {
                if let nearnode = currentNode{
                    box.update(to: endValue, with: nearnode)
                }else{
                    box.update(to: endValue, with: nil)
                }
                isNearNodeFound = false
            }
        }else{
            //finding any node is nearby targetNode
            self.findnearestNode(centerVector: worldPosition)
        }
    }
    
    fileprivate func findnearestNode(centerVector: SCNVector3) {
        localSceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            if node.name == "topLeftNode" || node.name == "topRightNode" || node.name == "bottomLeftNode" || node.name == "bottomRightNode"{
                let foundnodePosition = node.position
                let distance = foundnodePosition.distance(from: centerVector)
                if (distance <= 0.08) {
                    isNearNodeFound = true
                    nearValue = node.position
                    currentNode = node
                    changeNodeColor(node, color: UIColor.blue)
                }else{
                    changeNodeColor(node, color: UIColor.green)
                }
            }
        }
    }
    
    //Change Color of Node
    fileprivate func changeNodeColor(_ node: SCNNode, color: UIColor) {
        node.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    func resetMeasuremnets(){
        measuring = false
        startValue = SCNVector3()
        endValue =  SCNVector3()
        indexCount = 0
        currentbox?.removeFromParentNode()
        resetValues()
    }
    
    func resetValues() {
        startValue = SCNVector3()
        endValue =  SCNVector3()
        currentbox = nil
        isNearNodeFound = false
        currentNode = nil
    }
    
    func updateLineDetails(type line:LineType){
        if let currentline = currentLine{
            currentline.updateLineDetails(line: line)
        }
    }
    
    func meterButtonTapped(_ measureUnit: DistanceUnit){
        unit = measureUnit
    }
    
    func cropImageView() -> Bool {
        addNodesIntoArray()
        resetMeasuremnets()
        let screenshot = localSceneView.snapshot()
        imageViewObject.frame = localSceneView.frame
        imageViewObject.contentMode = .scaleToFill
        imageViewObject.image = screenshot
        if let croppedImage = ZImageCropper.cropImage(ofImageView: imageViewObject, withinPoints: points2D){
            points2D.removeAll()
            //Store Images in local DB
            if let isSaved =   file.saveImageDocumentDirectory(image: croppedImage.imageResize(sizeChange: localSceneView.frame.size)),isSaved{
                
                return true
            }else{
                return false
            }
        }
        return false        
    }
    
    fileprivate func addNodesIntoArray(){
        points2D.removeAll()
        if let box = currentbox{
            for node in box.cornerpoints{
                let foundnodePosition = node.position
                let point = localSceneView.projectPoint(foundnodePosition)
                points2D.append(CGPoint(x: Double(point.x), y: Double(point.y)))
            }
        }
    }
    
}
extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}
