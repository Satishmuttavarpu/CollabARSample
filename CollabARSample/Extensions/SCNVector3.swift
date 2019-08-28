//
//  SCNVector3.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 03/07/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import ARKit

extension SCNVector3 {
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func distance(from vector: SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        
        return sqrtf((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
    }
    
    func line(to vector: SCNVector3, color: UIColor = .white) -> SCNNode {
        let vertices: [SCNVector3] = [self, vector]
        let data = NSData(bytes: vertices, length: MemoryLayout<SCNVector3>.size * vertices.count) as Data
        
        let vertexSource = SCNGeometrySource(data: data,
                                             semantic: .vertex,
                                             vectorCount: vertices.count,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<SCNVector3>.stride)
        
        
        let indices: [Int32] = [ 0, 1]
        
        let indexData = NSData(bytes: indices, length: MemoryLayout<Int32>.size * indices.count) as Data
        
        let element = SCNGeometryElement(data: indexData,
                                         primitiveType: .line,
                                         primitiveCount: indices.count/2,
                                         bytesPerIndex: MemoryLayout<Int32>.size)
        
        let line = SCNGeometry(sources: [vertexSource], elements: [element])
        
        line.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        line.firstMaterial?.diffuse.contents = color
        
        let lineNode = SCNNode(geometry: line)
        return lineNode;
    }
    
    /*
     func line(to vector: SCNVector3, color: UIColor = .white) -> SCNNode {
     let indices: [Int32] = [0, 1]
     let source = SCNGeometrySource(vertices: [self, vector])
     let element = SCNGeometryElement(indices: indices, primitiveType: .line)
     let geometry = SCNGeometry(sources: [source], elements: [element])
     geometry.firstMaterial?.diffuse.contents = color
     let node = SCNNode(geometry: geometry)
     return node
     }
 */
}

extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}
