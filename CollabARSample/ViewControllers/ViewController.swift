//
//  ViewController.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 03/07/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    let viewModel : ViewControllerVM = ViewControllerVM()
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var meterButton: UIButton!
    fileprivate lazy var session = ARSession()
    fileprivate lazy var sessionConfiguration = ARWorldTrackingConfiguration()
    
    // MARK: - Debug properties
    var showDebugOptions = false {
        didSet {
            if showDebugOptions {
                sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
            } else {
                sceneView.debugOptions = []
            }
        }
    }
    
    //let projectedPoint = sceneView.projectPoint(pos)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARSceneSession()
    }
}
// MARK: - Privates
extension ViewController {
    
    fileprivate func setupARSceneSession() {
        // session configuration
        sceneView.session = session
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        // Show world origin and feature points if desired
        showDebugOptions = true
        // Enable default lighting
        sessionConfiguration.worldAlignment = .gravityAndHeading
        sessionConfiguration.isAutoFocusEnabled = true
        sessionConfiguration.isLightEstimationEnabled = true
        sessionConfiguration.planeDetection = [.vertical,.horizontal]
        // sessionConfiguration.planeDetection = [.horizontal,.vertical]
        // Run the view's session
        session.run(sessionConfiguration, options: [])
        //UI Elements
        loadingView.hidesWhenStopped = true
        loadingView.startAnimating()
        meterButton.isHidden = true
        targetLabel.isHidden = true
        messageLabel.text = "Hold screen & move your phone…"
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        if viewModel.indexCount < 1{
            viewModel.indexCount += 1
            viewModel.resetValues()
            viewModel.measuring = true
        }else{
            viewModel.measuring = false
            if viewModel.isNearNodeFound{
                viewModel.measuring = true
            }
        }
        
    }
    
    fileprivate func detectObjects() {
        guard let worldPosition = sceneView.realWorldVector(screenPosition: sceneView.center) else { return }
        meterButton.isHidden = false
        targetLabel.isHidden = false
        loadingView.stopAnimating()
        //Start Measure when Tap on sceneView
        viewModel.startMeasureLine(sceneView, worldPosition)
    }
    
    fileprivate func takeScreenShot(){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            var message = ""
            if weakSelf.viewModel.cropImageView(){
                message = "Screenshot has saved sucessfully"
            }else{
                message = "Screenshot has not saved sucessfully"
            }
            CollabAlertView.showAlert(title: "Alert", message: message, topViewcontroller: weakSelf)
        }
    }
    
    fileprivate func presentPhotoGallaryViewController(){
        let gallaryVC = self.storyboard!.instantiateViewController(withIdentifier: "GallaryViewController") as! GallaryViewController
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        let navController = UINavigationController(rootViewController: gallaryVC)
        self.present(navController, animated:true, completion: nil)
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.detectObjects()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            //1. Check We Have A Valid ARPlaneAnchor
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            //2. Get It's Alignment
            if planeAnchor.alignment == .horizontal{
                weakSelf.messageLabel.text = "ARPlaneAnchor is now Horizontal"
                //print("The ARPlaneAnchor Alignment == Horizontal")
            }else if planeAnchor.alignment == .vertical{
                weakSelf.messageLabel.text = "ARPlaneAnchor is now Vertical"
                //print("The ARPlaneAnchor Alignment == Vertical")
            }
        }
        
    }
    
}

// MARK: - Users Interactions
extension ViewController {
    
    
    @IBAction func clearMeasurements(){
        viewModel.resetMeasuremnets()
    }
    
    @IBAction func meterButtonTapped(button: UIButton) {
        let buttons = [DistanceUnit.centimeter.title, DistanceUnit.inch.title, DistanceUnit.meter.title]
        CollabAlertView.showAlertWithHandler(title: "Settings", message: "Please select distance unit options", buttonsTitles: buttons, showAsActionSheet: true, topViewcontroller: self){ [weak self] (index) in
            guard let weakSelf = self else { return }
            switch(index){
            case 0:
                weakSelf.viewModel.meterButtonTapped(.centimeter)
            case 1:
                weakSelf.viewModel.meterButtonTapped(.inch)
            case 2:
                weakSelf.viewModel.meterButtonTapped(.meter)
            default:
                print("Nothing")
            }
        }
    }
    
    @IBAction func CaemeraTapped(button: UIButton) {
        let buttons = ["Save", "Open Gallary", "Cancel"]
        
        CollabAlertView.showAlertWithHandler(title: "ScreenShot", message: "Take ScreenShot or Open Photo Gallary", buttonsTitles: buttons, showAsActionSheet: true, topViewcontroller: self) { [weak self] (index) in
            guard let weakSelf = self else { return }
            switch(index){
            case 0:
                weakSelf.takeScreenShot()
            case 1:
                weakSelf.presentPhotoGallaryViewController()
            case 2:
                print("Cancel")
            default:
                print("Nothing")
            }
        }
    }
    
}
