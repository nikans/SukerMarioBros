//
//  GameViewController.swift
//  TestGame
//
//  Created by Eliah Nikans on 6/28/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks")
        
        let sceneData = NSData.dataWithContentsOfMappedFile(path!) as! NSData
//        var sceneData = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
//        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
        let scene = GameScene(size: skView.bounds.size)
            // Configure the view.
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.position = CGPoint(x: 0, y: 0);
        skView.presentScene(scene)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func shouldAutorotate() -> Bool {
        return false
    }

//    override func supportedInterfaceOrientations() -> Int {        
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
//        } else {
//            return Int(UIInterfaceOrientationMask.All.toRaw())
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
