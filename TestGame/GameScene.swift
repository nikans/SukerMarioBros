//
//  GameScene.swift
//  TestGame
//
//  Created by Eliah Nikans on 6/28/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

import SpriteKit

enum MoveDirection: Int {
    case None, Forward, Backward
}

class GameScene: SKScene, UIGestureRecognizerDelegate, SKSceneDelegate, SKPhysicsContactDelegate {
    
    let map = JSTileMap(named: "level.tmx");
    var hero = SKSpriteNode(imageNamed: "marioSmall_standing");
    var obstacles = SKNode();
    var swipeJumpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer();
    
    var move: MoveDirection = .None;
    var isJumping: Bool = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.commonShitInit();
    }
    
    override init(size: CGSize) {
        super.init(size: size);
        self.commonShitInit();
    }
    
    func commonShitInit () -> () {
        
        // Setting Scene
        self.backgroundColor = UIColor(red: 104.0 / 255.0, green: 136.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0);
        self.addChild(self.map);
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y - 36.0, width: self.frame.size.width, height: self.frame.size.height));
        self.physicsBody?.friction = 0.0;
        self.physicsWorld.contactDelegate = self;
        //        self.physicsBody.collisionBitMask = 0;
        //        self.physicsBody.contactTestBitMask = 0;
        //        self.physicsWorld.gravity = CGVectorMake(0,0);
        //        self.physicsWorld.contactDelegate = self;
        
        
        // Setting obstacles
        let collisionsGroup: TMXObjectGroup = self.map.groupNamed("Collisions");
        for(var i = 0; i < collisionsGroup.objects.count; i++) {
            let collisionObject = collisionsGroup.objects.objectAtIndex(i) as! NSDictionary;
            
            print(collisionObject);
            
            let width = collisionObject.objectForKey("width") as! String;
            let height = collisionObject.objectForKey("height") as! String;
            let someObstacleSize = CGSize(width: Int(width)!, height: Int(height)!);
            
            let someObstacle = SKSpriteNode(color: UIColor.clearColor(), size: someObstacleSize);
            
            let y = collisionObject.objectForKey("y") as! Int;
            let x = collisionObject.objectForKey("x") as! Int;
            
            someObstacle.position = CGPoint(x: x + Int(collisionsGroup.positionOffset.x) + Int(width)!/2, y: y + Int(collisionsGroup.positionOffset.y) + Int(height)!/2);
            someObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: someObstacleSize);
            someObstacle.physicsBody?.affectedByGravity = false;
            someObstacle.physicsBody?.collisionBitMask = 0;
            someObstacle.physicsBody?.friction = 0.2;
            someObstacle.physicsBody?.restitution = 0.0;
            
            self.obstacles.addChild(someObstacle)
        }
        self.addChild(self.obstacles);
        
        // Setup Mario
        let startLocation = CGPoint(x: 64, y: 80);
        
        self.hero.position = startLocation;
        self.hero.size = CGSize(width: 32, height: 32);
        
        // Make 'im jumpy
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: self.hero.frame.size.width/2);
        self.hero.physicsBody?.friction = 0.2;
        self.hero.physicsBody?.restitution = 0;
        self.hero.physicsBody?.linearDamping = 0.0;
        self.hero.physicsBody?.allowsRotation = false;
        self.hero.physicsBody?.dynamic = true;
        
        // Animate running
        var marioSmall_running = [SKTexture]();
        for i in 0...2 {
            marioSmall_running.append( SKTexture(imageNamed: "marioSmall_running\(i)") );
        }
        let runningAction = SKAction.animateWithTextures(marioSmall_running, timePerFrame: 0.1);
        self.hero.runAction(SKAction.repeatActionForever(runningAction))
        
        self.addChild(self.hero)
        
//        var swipeJumpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer();
//        self.swipeJumpGesture.addTarget(self, action: Selector("handleJumpSwipe:"));
//        self.swipeJumpGesture.direction = .Up;
//        self.swipeJumpGesture.numberOfTouchesRequired = 1;
//        if let shit = self.view {
//            shit.addGestureRecognizer(self.swipeJumpGesture);
//        }
        
//        self.view.addGestureRecognizer(swipeJumpGesture);
//        if let shit = self.view {
//            shit.addGestureRecognizer(swipeJumpGesture);
//        }
    }
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view);
        
        self.swipeJumpGesture.addTarget(self, action: Selector("handleJumpSwipe:"));
        self.swipeJumpGesture.direction = .Up;
        self.swipeJumpGesture.numberOfTouchesRequired = 1;
        self.view!.addGestureRecognizer(self.swipeJumpGesture);
    }
    
    func handleJumpSwipe(sender: UIGestureRecognizer) {
        if !self.isJumping {
            self.marioJump();
            self.isJumping = true;
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            self.move = .None;
            self.isJumping = false;
        }
    }
    
    func marioJump() {
        self.hero.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 30), atPoint: CGPoint(x: self.hero.frame.width/2, y: 0));
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */

        for touch: AnyObject in touches {
            
            var touchMe: UITouch = touch as! UITouch;
            
//            if find(touchMe.gestureRecognizers, self.swipeJumpGesture) { continue; }
            
//            if event.touchesForGestureRecognizer(self.swipeJumpGesture).count > 0 {
//                continue;
//            }
//            if touch as UIGestureRecognizer == self.swipeJumpGesture {
//                continue;
//            }
            
            let location = touch.locationInNode(self);
            if location.x > self.hero.position.x {
                self.move = .Forward;
            }
            else {
                self.move = .Backward;
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.move = .None;
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.move = .None;
    }
   
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody  = contact.bodyA;
        let secondBody: SKPhysicsBody = contact.bodyB;
        
        if(self.isJumping == true && (firstBody.node == self.hero || secondBody.node == self.hero)) {
            self.isJumping = false;
            self.move = .None;
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        var speed: CGFloat = 15;
        
        if self.move == .Forward {
            let s = (self.map.position.x - speed - self.frame.width) * -1.0
            let w = self.map.mapSize.width * self.map.tileSize.width
            speed = s > w ? 0 : speed;

            self.obstacles.position.x -= speed
            self.map.position.x -= speed
//            self.physicsWorld.gravity = CGVector(-2,-9.8);
//            self.hero.physicsBody.applyForce(CGVector(5,0), atPoint: CGPoint(x: 0, y: self.hero.frame.size.height/2))
        }
        else if self.move == .Backward {
            speed = self.map.position.x + speed > 0 ? 0 : speed;
            
            self.obstacles.position.x += speed
            self.map.position.x += speed
//            self.physicsWorld.gravity = CGVector(2,-9.8);
//            self.hero.physicsBody.applyForce(CGVector(-5,0), atPoint: CGPoint(x: self.hero.frame.size.width, y: self.hero.frame.size.height/2))
        }
//        else {
//            self.physicsWorld.gravity = CGVector(0.0,-9.8);
//        }

        
//        self.map.position.x = -self.hero.position.x  // - self.frame.size.width / 2 + self.hero.frame.width / 2;
//        self.obstacles.position.x = -self.hero.position.x*0.5
    }
}
