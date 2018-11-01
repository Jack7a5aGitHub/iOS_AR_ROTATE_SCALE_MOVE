//
//  ViewController.swift
//  AR_Rotate_Move_Scale
//
//  Created by Jack Wong on 2018/04/13.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    private let configuration = ARWorldTrackingConfiguration()
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        registerGestureRecognizers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.1))
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        sphereNode.geometry?.firstMaterial?.specular.contents = UIColor.blue
        sphereNode.position = SCNVector3(0,0,-3)
        sceneView.scene.rootNode.addChildNode(sphereNode)
        print("Tapped")
    }
    
}

extension ViewController: ARSCNViewDelegate {
    private func setupConfiguration() {
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        //sceneView.showsStatistics = true
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
    }
}

extension ViewController {
    private func registerGestureRecognizers() {
        let pinchGesturRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchObject))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotateObject))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveObject))
        longPressGestureRecognizer.minimumPressDuration = 0.2
        sceneView.addGestureRecognizer(pinchGesturRecognizer)
       // sceneView.addGestureRecognizer(longPressGestureRecognizer)
        sceneView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func pinchObject(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        if !hitTest.isEmpty {
            let result = hitTest.first!
            let node = result.node
            print("result: \(result)")
            print("node: \(node)")
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
    }
    @objc private func rotateObject(sender: UILongPressGestureRecognizer){
        let sceneView = sender.view as! ARSCNView
        let holdLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(holdLocation)
        sender.allowableMovement = true 
        if !hitTest.isEmpty {
            let result = hitTest.first!
            let node = result.node
            switch sender.state {
            case .began:
                print("holding")
//                let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 1)
//                let forever = SCNAction.repeatForever(action)
//                node.runAction(forever)
            case .ended:
              
                result.node.removeAllActions()
            case .possible:
                break
            case .changed:
                break
            case .cancelled:
                break
            case .failed:
                break
            }
        }
        
    }
    @objc private func moveObject(sender: UIPanGestureRecognizer) {
        
        let sceneView = sender.view as! ARSCNView
        let panLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(panLocation)
        if !hitTest.isEmpty {
        let result = hitTest.first!
        let node = result.node
            
        switch sender.state {
            
        case .possible:
            break
        case .began:
        print("Began Paning")
            
        case .changed:
           print("changing")
        case .ended:
            print("finished")
        case .cancelled:
            break
        case .failed:
            break
        }
    }
    }
}
