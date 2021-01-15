//
//  GameViewController.swift
//  Snakeish
//
//  Created by Luc Van Den Handel on 2021/01/04.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.bounds.size)
                // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            let skViewSize = view.bounds.size
            scene.size = CGSize(width: skViewSize.width, height: skViewSize.height)
                
                // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

   
}
