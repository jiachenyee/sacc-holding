//
//  GameViewController.swift
//  SwiftAcceleratorCommunityConference
//
//  Created by Jia Chen Yee on 4/11/23.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    override func keyDown(with event: NSEvent) {
        
        Task {
            let scnView = self.view as! SCNView
            
            let scene = scnView.scene!
            
            let textFieldNode = scene.rootNode.childNode(withName: "TextField", recursively: true)!
            let textFieldContentsNode = textFieldNode.childNode(withName: "content", recursively: false)!
            let textFieldSelectionNode = textFieldNode.childNode(withName: "selection", recursively: false)!
            let textFieldCursorNode = textFieldNode.childNode(withName: "cursor", recursively: false)!
            
            await MainActor.run {
                SCNTransaction.begin()
                
                SCNTransaction.animationDuration = 1
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                let child = scnView.scene?.rootNode.childNode(withName: "camera2", recursively: true)
                scnView.pointOfView = child
                
                SCNTransaction.commit()
            }
            
            try await Task.sleep(for: .seconds(1.5))
            
            await MainActor.run {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0
                
                (textFieldContentsNode.geometry as! SCNText).string = "We’ll begin …"
                textFieldSelectionNode.isHidden = true
                SCNTransaction.commit()
            }
            
            try await Task.sleep(for: .seconds(0.4))
            await MainActor.run {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0
                (textFieldContentsNode.geometry as! SCNText).string = "We’ll begin n…"
                
                textFieldCursorNode.runAction(.move(by: .init(x: 0, y: 0, z: 0.1), duration: 0.1))
                
                SCNTransaction.commit()
            }
            
            try await Task.sleep(for: .seconds(0.4))
            await MainActor.run {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0
                (textFieldContentsNode.geometry as! SCNText).string = "We’ll begin no…"
                textFieldCursorNode.runAction(.move(by: .init(x: 0, y: 0, z: 0.1), duration: 0.1))
                SCNTransaction.commit()
            }
            
            try await Task.sleep(for: .seconds(0.4))
            await MainActor.run {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0
                (textFieldContentsNode.geometry as! SCNText).string = "We’ll begin now…"
                textFieldCursorNode.runAction(.move(by: .init(x: 0, y: 0, z: 0.1), duration: 0.1))
                SCNTransaction.commit()
            }
            
            try await Task.sleep(for: .seconds(0.4))
            await MainActor.run {
                textFieldCursorNode.runAction(.fadeOut(duration: 0.1))
            }
            
            try await Task.sleep(for: .seconds(0.5))
            await MainActor.run {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeIn)
                
                let child = scnView.scene?.rootNode.childNode(withName: "camera3", recursively: true)
                scnView.pointOfView = child
                SCNTransaction.commit()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = NSColor.black
        
        let child = scnView.scene?.rootNode.childNode(withName: "camera", recursively: true)
        scnView.pointOfView = child
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
        runTrackAnimation()
    }
    
    func runTrackAnimation() {
        let scnView = self.view as! SCNView
        
        let track = scnView.scene?.rootNode.childNode(withName: "track", recursively: true)
        let trackCylinder = scnView.scene?.rootNode.childNode(withName: "TrackCylinder", recursively: true)
        let box = track?.geometry as? SCNBox
        box?.length = 0.1
        
        track?.position = SCNVector3(x: -0.65, y: 0, z: 2.05 - 0.7)
        trackCylinder?.position = SCNVector3(x: -0.649, y: 0.003, z: 1.455)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 10
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .linear)
        box?.length = 1.5
        track?.position = SCNVector3(x: -0.65, y: 0, z: 2.05)
        trackCylinder?.position = SCNVector3(x: -0.649, y: 0.003, z: 1.455 + 1.2)
        
        SCNTransaction.completionBlock = {
            self.runReverseTrackAnimation()
        }
        SCNTransaction.commit()
    }
    
    func runReverseTrackAnimation() {
        let scnView = self.view as! SCNView
        
        let track = scnView.scene?.rootNode.childNode(withName: "track", recursively: true)
        let trackCylinder = scnView.scene?.rootNode.childNode(withName: "TrackCylinder", recursively: true)
        let box = track?.geometry as? SCNBox
        
        box?.length = 1
        
        track?.position = SCNVector3(x: -0.65, y: 0, z: 2.05)
        trackCylinder?.position = SCNVector3(x: -0.649, y: 0.003, z: 1.455 + 1.2)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 10
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .linear)
        box?.length = 0.1
        track?.position = SCNVector3(x: -0.65, y: 0, z: 2.05 - 0.7)
        trackCylinder?.position = SCNVector3(x: -0.649, y: 0.003, z: 1.455)
        
        SCNTransaction.completionBlock = {
            self.runTrackAnimation()
        }
        SCNTransaction.commit()
    }
    
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
        }
    }
}
