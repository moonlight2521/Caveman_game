//
//  GameScene.swift
//  MazeMan
//
//  Created by Zun Lin on 4/10/18.
//  Copyright © 2018 Zun Lin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let background = SKSpriteNode(imageNamed: "bg")
    let caveman = SKSpriteNode(imageNamed: "caveman")
//    let block = SKSpriteNode(imageNamed: "block")
//    let water = SKSpriteNode(imageNamed: "water")
    let star = SKSpriteNode(imageNamed: "star")
    let food = SKSpriteNode(imageNamed: "food")
    let rock = SKSpriteNode(imageNamed: "rock")
//    let battery = SKSpriteNode(imageNamed: "battery")
//    let heart = SKSpriteNode(imageNamed: "heart")
//    let fire = SKSpriteNode(imageNamed: "fire")
    let dino1 = SKSpriteNode(imageNamed: "dino1")
    let dino2 = SKSpriteNode(imageNamed: "dino2")
    let dino3 = SKSpriteNode(imageNamed: "dino3")
    let dino4 = SKSpriteNode(imageNamed: "dino4")
    
    //Labels
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    let rockLabel = SKLabelNode(fontNamed: "Chalkduster")
    let heartLabel = SKLabelNode(fontNamed: "Chalkduster")
    let batteryLabel = SKLabelNode(fontNamed: "Chalkduster")
    let stutesLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    //labelValues
    var scoreValue = 0
    var rockValue = 10
    var heartValue = 3
    var batteryValue = 100
    var stutesValue = "Hello, Welcome to MazeMan!"
    //set values
    var matrix = Array(repeating: Array(repeating: false, count: 16), count: 10)
    var cpositionX = 0
    var cpositionY = 0
    var blockCount = 0
    var gameTime = 0
    var score = 0
    var dino1Dmg = -60
    var dino2Dmg = -80
    var dino3Dmg = -100
    var fireballDmg = -100
    var foodEng = 50

    var location = CGPoint()

    
    var addfire = true
    var gravity = true
    
    var addblockTimer = Timer()
    var addFireTimer = Timer()
    var addGravityTimer = Timer()
    var gravityTimer = Timer()
    var firrballTimer = Timer()
    var addrockTimer = Timer()
    var gameTimer = Timer()
    var batteryTimer = Timer()
    
    
    var tapGR: UITapGestureRecognizer!
    var swipeRightGR: UISwipeGestureRecognizer!
    var swipeLeftGR: UISwipeGestureRecognizer!
    var swipeUpGR: UISwipeGestureRecognizer!
    var swipeDownGR: UISwipeGestureRecognizer!
    
    let right = SKAction.moveBy(x: 84, y: 0, duration: 0.5)
    let left = SKAction.moveBy(x: -84, y: 0, duration: 0.5)
    let up = SKAction.moveBy(x: 0, y: 84, duration: 0.5)
    let down = SKAction.moveBy(x: 0, y: -84, duration: 0.5)

    
//run game.............................................................................
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        addBackGround()
        addScreen()
        addcaveMan()
        addDino1()
        addDino2()
        addDino3()
        addDino4()
        addstar()
        addfood()
        allTimer()
        addGR()
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.caveman && contact.bodyB.categoryBitMask == PhysicsCategory.dino1) || (contact.bodyA.categoryBitMask == PhysicsCategory.dino1 && contact.bodyB.categoryBitMask == PhysicsCategory.caveman)) {
            self.run(SKAction.playSoundFileNamed("gotHit", waitForCompletion: false))
            batteryPower(point: dino1Dmg)
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.caveman && contact.bodyB.categoryBitMask == PhysicsCategory.dino2) || (contact.bodyA.categoryBitMask == PhysicsCategory.dino2 && contact.bodyB.categoryBitMask == PhysicsCategory.caveman)) {
            self.run(SKAction.playSoundFileNamed("gotHit", waitForCompletion: false))
            batteryPower(point: dino2Dmg)
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.caveman && contact.bodyB.categoryBitMask == PhysicsCategory.dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.caveman)) {
            self.run(SKAction.playSoundFileNamed("gotHit", waitForCompletion: false))
            batteryPower(point: dino3Dmg)
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.caveman && contact.bodyB.categoryBitMask == PhysicsCategory.fire) || (contact.bodyA.categoryBitMask == PhysicsCategory.fire && contact.bodyB.categoryBitMask == PhysicsCategory.caveman)) {
            self.run(SKAction.playSoundFileNamed("gotHit", waitForCompletion: false))
            batteryPower(point: dino1Dmg)
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.caveman && contact.bodyB.categoryBitMask == PhysicsCategory.water) || (contact.bodyA.categoryBitMask == PhysicsCategory.water && contact.bodyB.categoryBitMask == PhysicsCategory.caveman)) {
            caveman.removeFromParent()
            stutesValue = "You die, Game Over!"
            stutesLabel.text = stutesValue.description
            self.run(SKAction.playSoundFileNamed("death", waitForCompletion: true))
            gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(endgame), userInfo: nil, repeats: false)
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.caveman && contact.bodyB.categoryBitMask == PhysicsCategory.food) || (contact.bodyA.categoryBitMask == PhysicsCategory.food && contact.bodyB.categoryBitMask == PhysicsCategory.caveman)) {
            self.run(SKAction.playSoundFileNamed("bite", waitForCompletion: false))
            food.removeFromParent()
            addfood()
            stutesValue = "You Gain Energy"
            stutesLabel.text = stutesValue.description
            batteryPower(point: foodEng)
        }
        else if ((contact.bodyA.categoryBitMask == PhysicsCategory.caveman && contact.bodyB.categoryBitMask == PhysicsCategory.star) || (contact.bodyA.categoryBitMask == PhysicsCategory.star && contact.bodyB.categoryBitMask == PhysicsCategory.caveman)) {
            self.run(SKAction.playSoundFileNamed("spell3", waitForCompletion: false))
            star.removeFromParent()
            addstar()
            stutesValue = "You Gain a point"
            stutesLabel.text = stutesValue.description
            scoreValue += 1
            scoreLabel.text = scoreValue.description
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.dino1 && contact.bodyB.categoryBitMask == PhysicsCategory.food) || (contact.bodyA.categoryBitMask == PhysicsCategory.food && contact.bodyB.categoryBitMask == PhysicsCategory.dino1)) {
            self.run(SKAction.playSoundFileNamed("bite", waitForCompletion: false))
            food.removeFromParent()
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addfood), userInfo: nil, repeats: false)
            stutesValue = "Food will respwan in 10s"
            stutesLabel.text = stutesValue.description
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.dino2 && contact.bodyB.categoryBitMask == PhysicsCategory.food) || (contact.bodyA.categoryBitMask == PhysicsCategory.food && contact.bodyB.categoryBitMask == PhysicsCategory.dino2)) {
            self.run(SKAction.playSoundFileNamed("bite", waitForCompletion: false))
            food.removeFromParent()
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addfood), userInfo: nil, repeats: false)
            stutesValue = "Food will respwan in 10s"
            stutesLabel.text = stutesValue.description
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.food) || (contact.bodyA.categoryBitMask == PhysicsCategory.food && contact.bodyB.categoryBitMask == PhysicsCategory.dino3)) {
            self.run(SKAction.playSoundFileNamed("bite", waitForCompletion: false))
            food.removeFromParent()
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addfood), userInfo: nil, repeats: false)
            stutesValue = "Food will respwan in 10s"
            stutesLabel.text = stutesValue.description
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.dino1 && contact.bodyB.categoryBitMask == PhysicsCategory.rock) || (contact.bodyA.categoryBitMask == PhysicsCategory.rock && contact.bodyB.categoryBitMask == PhysicsCategory.dino1)){
            dino1.removeFromParent()
            self.run(SKAction.playSoundFileNamed("monsterDie", waitForCompletion: false))
            let i = Double(arc4random_uniform(5)+1)
            Timer.scheduledTimer(timeInterval: i, target: self, selector: #selector(addDino1), userInfo: nil, repeats: false)
            stutesValue = "You kill dino1, it will respawn in \(i)s"
            stutesLabel.text = stutesValue.description
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.dino2 && contact.bodyB.categoryBitMask == PhysicsCategory.rock) || (contact.bodyA.categoryBitMask == PhysicsCategory.rock && contact.bodyB.categoryBitMask == PhysicsCategory.dino2)){
            dino2.removeFromParent()
            self.run(SKAction.playSoundFileNamed("monsterDie", waitForCompletion: false))
            let i = Double(arc4random_uniform(5)+1)
            Timer.scheduledTimer(timeInterval: i, target: self, selector: #selector(addDino2), userInfo: nil, repeats: false)
            stutesValue = "You kill dino2, it will respawn in \(i)s"
            stutesLabel.text = stutesValue.description
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.rock) || (contact.bodyA.categoryBitMask == PhysicsCategory.rock && contact.bodyB.categoryBitMask == PhysicsCategory.dino3)){
            dino3.removeFromParent()
            self.run(SKAction.playSoundFileNamed("monsterDie", waitForCompletion: false))
            let i = Double(arc4random_uniform(5)+1)
            Timer.scheduledTimer(timeInterval: i, target: self, selector: #selector(addDino3), userInfo: nil, repeats: false)
            stutesValue = "You kill dino3, it will respawn in \(i)s"
            stutesLabel.text = stutesValue.description
        } else if ((contact.bodyA.categoryBitMask == PhysicsCategory.block && contact.bodyB.categoryBitMask == PhysicsCategory.dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.block)){
            dino3.removeAction(forKey: "dino3_move")
            dino3Moves()
        }
    }
    //add Geaster fucntion......................................................................................
    func addGR(){
        tapGR = UITapGestureRecognizer(target: self, action: #selector(isTap))
        tapGR.numberOfTapsRequired = 1
        view?.addGestureRecognizer(tapGR)
        
        swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightGR.direction = .right
        view?.addGestureRecognizer(swipeRightGR)
        
        swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGR.direction = .left
        view?.addGestureRecognizer(swipeLeftGR)
        
        swipeUpGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeUpGR.direction = .up
        view?.addGestureRecognizer(swipeUpGR)
        
        swipeDownGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeDownGR.direction = .down
        view?.addGestureRecognizer(swipeDownGR)
    }
    
    //add swipe right............................................................................................
    @objc func swipeRight(sender:UISwipeGestureRecognizer){
        print("swiped right")
        if (caveman.xScale < 0) {
            caveman.xScale = caveman.xScale * -1
        }
        caveman.run(SKAction.repeatForever(right), withKey: "caveman_move_right")
        caveman.removeAction(forKey: "caveman_move_left")
        caveman.removeAction(forKey: "caveman_move_up")
        caveman.removeAction(forKey: "caveman_move_down")

    }
    //add swipe right............................................................................................
    @objc func swipeLeft(sender:UISwipeGestureRecognizer){
        print("swiped left")
        if (caveman.xScale > 0) {
            caveman.xScale = caveman.xScale * -1
        }
        caveman.run(SKAction.repeatForever(left), withKey: "caveman_move_left")
        caveman.removeAction(forKey: "caveman_move_right")
        caveman.removeAction(forKey: "caveman_move_up")
        caveman.removeAction(forKey: "caveman_move_down")
    }
    //add swipe up............................................................................................
    @objc func swipeUp(sender:UISwipeGestureRecognizer){
        print("swiped up")
        caveman.run(SKAction.repeatForever(up), withKey: "caveman_move_up")
        caveman.removeAction(forKey: "caveman_move_right")
        caveman.removeAction(forKey: "caveman_move_left")
        caveman.removeAction(forKey: "caveman_move_down")
    }
    //add swipe up............................................................................................
    @objc func swipeDown(sender:UISwipeGestureRecognizer){
        print("swiped down")
        caveman.run(SKAction.repeatForever(down), withKey: "caveman_move_down")
        caveman.removeAction(forKey: "caveman_move_right")
        caveman.removeAction(forKey: "caveman_move_left")
        caveman.removeAction(forKey: "caveman_move_up")
    }
    
    //add tapping Geasture............................................................................................
    @objc func isTap(sender:UITapGestureRecognizer) {
        print("tapped")
      //  var location = CGPoint()
        location = sender.location(in: self.view)
        location = self.convertPoint(fromView: location)
        if (rockValue > 0) {
            let rock = SKSpriteNode(imageNamed:"rock")
            rock.size = CGSize(width: 62, height: 62)
            rock.position = caveman.position
            rock.zPosition = 1.0
            rock.physicsBody = SKPhysicsBody(circleOfRadius: rock.frame.width / 2)
            rock.physicsBody?.isDynamic = true
            rock.physicsBody?.affectedByGravity = false
            rock.physicsBody?.categoryBitMask = PhysicsCategory.rock
            rock.physicsBody?.collisionBitMask = PhysicsCategory.none
            rock.physicsBody?.contactTestBitMask = PhysicsCategory.dino1 | PhysicsCategory.dino2 | PhysicsCategory.dino3
            
            let offset = location - rock.position
            let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi), duration:0.5)
            rock.run(SKAction.repeatForever(rotate))
            self.addChild(rock)
            let direction = offset.normalized()
            let addDest = direction * 1500
            let length = rock.position + addDest
            self.run(SKAction.playSoundFileNamed("pitch_baseball", waitForCompletion: false))
            rock.run(SKAction.sequence([SKAction.move(to: length, duration: 4), SKAction.removeFromParent()]))
            rockValue -= 1
            rockLabel.text = rockValue.description
        }
    }
    //add the scen..................................................................................
    func addScreen(){
        //add ground.............................................................
        for i in 0...15{
            if(i == 5 || i == 11){
                let water = SKSpriteNode(imageNamed: "water")
                water.size = CGSize(width: 85, height: 80)
                water.physicsBody = SKPhysicsBody(rectangleOf: water.size)
                water.position = CGPoint(x: 42.55 + Double(i) * 85  , y: 42.5)
                water.physicsBody?.affectedByGravity = false
                water.physicsBody?.isDynamic = false
                water.physicsBody?.categoryBitMask = PhysicsCategory.water
                water.physicsBody?.collisionBitMask = PhysicsCategory.none
                water.physicsBody?.contactTestBitMask = PhysicsCategory.caveman
                self.addChild(water)
                water.zPosition = 0.5
            } else {
                let block = SKSpriteNode(imageNamed: "block")
                block.size = CGSize(width: 85, height: 85)
                block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                block.position = CGPoint(x: 42.5 + Double(i) * 85.5  , y: 42.5)
                block.physicsBody?.affectedByGravity = false
                block.physicsBody?.isDynamic = false
                block.physicsBody?.categoryBitMask = PhysicsCategory.block
                block.physicsBody?.contactTestBitMask = PhysicsCategory.caveman

                self.addChild(block)
                block.zPosition = 0.5
            }
        }
        //add ceiling.............................................................
        for k in 0...1{
            for i in 0...15{
                let block = SKSpriteNode(imageNamed: "block")
                block.size = CGSize(width: 85, height: 85)
                block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                block.position = CGPoint(x: 42.5 + Double(i) * 85.5, y: 990 - Double(k) * 85)
                block.physicsBody?.affectedByGravity = false
                block.physicsBody?.isDynamic = false
                block.physicsBody?.categoryBitMask = PhysicsCategory.block
                block.physicsBody?.contactTestBitMask = PhysicsCategory.caveman

                self.addChild(block)
                block.zPosition = 0.5
            }
        }
        //add left bound.............................................................
        let leftBound = SKNode()
        leftBound.position = CGPoint(x: 0, y: self.frame.width / 3)
        leftBound.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: self.frame.height))
        addChild(leftBound)
        leftBound.physicsBody?.isDynamic = false
        leftBound.physicsBody?.categoryBitMask = PhysicsCategory.block
        leftBound.physicsBody?.contactTestBitMask = PhysicsCategory.caveman

        
        //add left bound.............................................................
        let rightBound = SKNode()
        rightBound.position = CGPoint(x: 1366, y: self.frame.width / 3)
        rightBound.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: self.frame.height))
        addChild(rightBound)
        rightBound.physicsBody?.isDynamic = false
        rightBound.physicsBody?.categoryBitMask = PhysicsCategory.block
        rightBound.physicsBody?.contactTestBitMask = PhysicsCategory.caveman

        
        //add scoreIcon.............................................................
        let score = SKSpriteNode(imageNamed: "star")
        score.size = CGSize(width: 84, height: 84)
        score.position = CGPoint(x: 42 , y: 42)
        score.zPosition = 0.6

        scoreLabel.text = scoreValue.description
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: 40, y: 22)
        scoreLabel.zPosition = 0.7
        
        self.addChild(score)
        self.addChild(scoreLabel)
        
        //add rockIcon.............................................................
        let rockIcon = SKSpriteNode(imageNamed: "rock")
        rockIcon.size = CGSize(width: 84 , height: 84)
        rockIcon.position = CGPoint(x: 42 + 84  , y: 42)
        rockIcon.zPosition = 0.6

        rockLabel.text = rockValue.description
        rockLabel.fontSize = 50
        rockLabel.position = CGPoint(x: 40 + 84, y: 22)
        rockLabel.zPosition = 0.7
    
        self.addChild(rockIcon)
        self.addChild(rockLabel)
        
        //add heartIcon.............................................................
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.size = CGSize(width: 84 , height: 84)
        heart.position = CGPoint(x: 42 + 84 * 2, y: 42)
        heart.zPosition = 0.6

        heartLabel.text = heartValue.description
        heartLabel.fontSize = 50
        heartLabel.position = CGPoint(x: 40 + 84 * 2, y: 22)
        heartLabel.zPosition = 0.7
        
        self.addChild(heart)
        self.addChild(heartLabel)
        
        //add energyIcon.............................................................
        let battery = SKSpriteNode(imageNamed: "battery")
        battery.size = CGSize(width: 126 , height: 126)
        battery.position = CGPoint(x: 60 + 82 * 3, y: 42)
        battery.zPosition = 0.6
        
        batteryLabel.text = batteryValue.description
        batteryLabel.fontSize = 40
        batteryLabel.position = CGPoint(x: 55 + 84 * 3, y: 30)
        batteryLabel.zPosition = 0.7
        
        self.addChild(battery)
        self.addChild(batteryLabel)
        
        //add stutesBar.............................................................
        let stutes = SKSpriteNode(imageNamed: "game-status-panel")
        stutes.size = CGSize(width: 1350 , height: 160)
        stutes.position = CGPoint(x: (view?.frame.width)! / 2, y: 940)
        stutes.zPosition = 0.6
        
        stutesLabel.text = stutesValue.description
        stutesLabel.fontSize = 50
        stutesLabel.position = CGPoint(x: (view?.frame.width)!/2, y: 960)
        stutesLabel.zPosition = 0.7
        
        self.addChild(stutes)
        self.addChild(stutesLabel)
    }
    //add caveman..........................................................................
    func addcaveMan(){
        caveman.size = CGSize(width: 84, height: 84)
        caveman.physicsBody = SKPhysicsBody(circleOfRadius: caveman.frame.width / 2)
        caveman.position = CGPoint(x: 42 , y: 88)
        caveman.physicsBody?.isDynamic = true
        caveman.physicsBody?.affectedByGravity = false
        caveman.physicsBody?.categoryBitMask = PhysicsCategory.caveman
        caveman.physicsBody?.collisionBitMask = PhysicsCategory.block
        caveman.physicsBody?.contactTestBitMask = PhysicsCategory.dino1 | PhysicsCategory.dino2 | PhysicsCategory.dino3 | PhysicsCategory.dino4 | PhysicsCategory.fire | PhysicsCategory.food | PhysicsCategory.star | PhysicsCategory.block | PhysicsCategory.water
        caveman.zPosition = 1.0
        self.addChild(caveman)
        matrix[0][1] = true
        matrix[1][0] = true
    }
    //add Dino1.............................................................................
    @objc func addDino1(){
        let i = Int(arc4random_uniform(UInt32(2)))
        dino1.size = CGSize(width: 84, height: 84)
        dino1.physicsBody = SKPhysicsBody(circleOfRadius: dino1.frame.width / 2.5)
        if i == 0 {
            dino1.position = CGPoint(x: 42.55 + 5 * 85 , y: 42)
        } else{
            dino1.position = CGPoint(x: 42.55 + 11 * 85 , y: 42)
        }
        dino1.physicsBody?.isDynamic = true
        dino1.physicsBody?.affectedByGravity = false
        dino1.physicsBody?.categoryBitMask = PhysicsCategory.dino1
        dino1.physicsBody?.collisionBitMask = PhysicsCategory.none
        dino1.physicsBody?.contactTestBitMask = PhysicsCategory.caveman | PhysicsCategory.food | PhysicsCategory.rock
        dino1.zPosition = 1.0
        self.addChild(dino1)
        let moveUp = SKAction.repeat(SKAction.moveBy(x: 0, y: 85, duration: 0.5), count: 9)
        let moveDown = SKAction.repeat(SKAction.moveBy(x: 0, y: -85, duration: 0.5), count: 9)
        //delay action 1 - 3 seconds
        let wait = SKAction.wait(forDuration: 1.5, withRange: 3)
        dino1.run(SKAction.repeatForever(SKAction.sequence([moveUp, wait, moveDown, wait])), withKey: "dino1")
    }
    //add Dino2.............................................................................
    @objc func addDino2(){
        let i = Int(arc4random_uniform(UInt32(5))) + 3
        dino2.size = CGSize(width: 84, height: 84)
        dino2.physicsBody = SKPhysicsBody(circleOfRadius: dino2.frame.width / 2.5)
        dino2.position = CGPoint(x: 1320 , y: 42 + i * 85)
      
        dino2.physicsBody?.isDynamic = true
        dino2.physicsBody?.affectedByGravity = false
        dino2.physicsBody?.categoryBitMask = PhysicsCategory.dino2
        dino2.physicsBody?.collisionBitMask = PhysicsCategory.none
        dino2.physicsBody?.contactTestBitMask = PhysicsCategory.caveman | PhysicsCategory.food | PhysicsCategory.rock
        dino2.zPosition = 1.0
        self.addChild(dino2)
        let moveLeft = SKAction.repeat(SKAction.moveBy(x: -85, y: 0, duration: 0.5), count: 15)
        let moveRight = SKAction.repeat(SKAction.moveBy(x:85, y: 0, duration: 0.5), count: 15)
        let flipLeft = SKAction.scaleX(to: 1, duration: 0)
        let flipRight = SKAction.scaleX(to: -1, duration: 0)
        //delay action 1 - 3 seconds
        let delay = SKAction.wait(forDuration: 1.5, withRange: 3)
        dino2.run(SKAction.repeatForever(SKAction.sequence([moveLeft, flipRight, delay, moveRight, delay, flipLeft])), withKey: "dino2")
    }
    //add Dino3.............................................................................
    @objc func addDino3(){
        dino3.size = CGSize(width: 84, height: 84)
        dino3.physicsBody = SKPhysicsBody(circleOfRadius: dino3.frame.width / 2.7)
        dino3.position = CGPoint(x: 1320 , y: 870)
        
        dino3.physicsBody?.isDynamic = true
        dino3.physicsBody?.affectedByGravity = false
        dino3.physicsBody?.categoryBitMask = PhysicsCategory.dino3
        dino3.physicsBody?.collisionBitMask = PhysicsCategory.block
        dino3.physicsBody?.contactTestBitMask = PhysicsCategory.caveman | PhysicsCategory.block | PhysicsCategory.food | PhysicsCategory.rock
        dino3.zPosition = 1.0
        self.addChild(dino3)
        dino3Moves()
    }
    func dino3Moves(){
        let flipLeft = SKAction.scaleX(to: -1, duration: 0)
        let flipRight = SKAction.scaleX(to: 1, duration: 0)
        let rotateUp = SKAction.rotate(toAngle: 3.14 / 2, duration: 0.2, shortestUnitArc: true)
        let rotateDown = SKAction.rotate(toAngle: -3.14 / 2, duration: 0.2, shortestUnitArc: true)

        let moveLeft = SKAction.repeat(SKAction.moveBy(x: -85, y: 0, duration: 0.5), count: 15)
        let moveRight = SKAction.repeat(SKAction.moveBy(x:85, y: 0, duration: 0.5), count: 15)
        let moveUp = SKAction.repeat(SKAction.moveBy(x: 0, y: 85, duration: 0.5), count: 9)
        let moveDown = SKAction.repeat(SKAction.moveBy(x: 0, y: -85, duration: 0.5), count: 9)
        
        let delay = SKAction.wait(forDuration: 1.5, withRange: 3)
        let i = Int(arc4random_uniform(4))
//        print(i)
        switch(i){
        case 0:
            //dino_move_left
            if (dino3.xScale < 0 && dino3.yScale < 0) {
                dino3.xScale = dino3.xScale * -1
                dino3.zRotation = dino3.yScale * -1
            }
            dino3.run(SKAction.sequence([delay, flipLeft, moveLeft, flipRight, moveRight]), withKey: "dino3_move")
            break
        case 1:
            //dino_move_down
            dino3.run(SKAction.sequence([delay, flipRight, rotateUp, flipLeft, moveDown]), withKey: "dino3_move")
            break
        case 2:
            if (dino3.xScale > 0 && dino3.yScale > 0 ) {
                dino3.xScale = dino3.xScale * -1
                dino3.zRotation = dino3.yScale * -1
            }
            //dino_move_right
            dino3.run(SKAction.sequence([delay, flipRight, moveRight]), withKey: "dino3_move")
            break
        case 3:
            //dino_move_up
            dino3.run(SKAction.sequence([delay,flipLeft, rotateDown, moveUp]), withKey: "dino3_move")
        default: break
        }
    }
    
    //add Dino4.............................................................................
    func addDino4(){
        dino4.size = CGSize(width: 134, height: 84)
        dino4.physicsBody = SKPhysicsBody(circleOfRadius: dino4.frame.width / 2.5)
        dino4.position = CGPoint(x: 1320 , y: 910)
        dino4.physicsBody?.isDynamic = false
        dino4.physicsBody?.affectedByGravity = false
        dino4.physicsBody?.categoryBitMask = PhysicsCategory.dino4
        dino4.physicsBody?.collisionBitMask = PhysicsCategory.none

        dino4.zPosition = 1.0
        self.addChild(dino4)
        
        let moveLeft = SKAction.repeat(SKAction.moveBy(x: -85, y: 0, duration: 0.5), count: 15)
        let moveRight = SKAction.repeat(SKAction.moveBy(x:85, y: 0, duration: 0.5), count: 15)
        dino4.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])), withKey: "dino4")
    }
    //add random block.............................................................................
    @objc func addRandBlock(){
        let positionX = Int((caveman.position.x + 1) - 42 / 84)
        let positionY = Int((caveman.position.x + 1) - 42 / 84)
        var didOccur = false
        var randomX = 0
        var randomY = 0
        
        while(!didOccur){
            randomX = Int(arc4random_uniform(16))
            randomY = Int(arc4random_uniform(9)+1)
            if (!matrix[randomY][randomX] && ((randomX != positionX) || (randomY != positionY)) ) {
                matrix[randomY][randomX] = true
                didOccur = true
            }
        }
        let block = SKSpriteNode(imageNamed: "block")
        block.size = CGSize(width: 85, height: 85)
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.position = CGPoint(x: 42.5 + Double(randomX) * 85.5  , y: 45 + Double(randomY) * 85.75)

        block.physicsBody?.affectedByGravity = false
        block.physicsBody?.isDynamic = false
        block.physicsBody?.categoryBitMask = PhysicsCategory.block
        self.addChild(block)
        block.zPosition = 0.5
        blockCount += 1
        if(blockCount > 15){
            addblockTimer.invalidate()
        }
    }
    
    //add fireball.............................................................................
    @objc func addFireball(){
        let dino4position = dino4.position
        let fire = SKSpriteNode(imageNamed: "fire")
        fire.size = CGSize(width: 84, height: 84)
        fire.position = CGPoint(x: dino4position.x, y: dino4position.y-CGFloat(10))
        fire.zPosition = 1
        fire.physicsBody = SKPhysicsBody(circleOfRadius: dino3.frame.width / 2.5)
        fire.physicsBody?.affectedByGravity = false
        fire.physicsBody?.isDynamic = false
        fire.physicsBody?.categoryBitMask = PhysicsCategory.fire
        fire.physicsBody?.contactTestBitMask = PhysicsCategory.caveman
        fire.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.addChild(fire)
        let fireDown = SKAction.moveTo(y: -30.0, duration: 5.0)
        fire.run(SKAction.playSoundFileNamed("fire", waitForCompletion: false))
        fire.run(fireDown, completion: {fire.removeFromParent()})
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi), duration:0.5)
        fire.run(SKAction.repeatForever(rotate))
        addfire = true
    }
    
    @objc func dropFireball(){
        if(addfire){
            let i = Double(arc4random_uniform(UInt32(5)) + 1)
            firrballTimer = Timer.scheduledTimer(timeInterval: i, target: self, selector: #selector(addFireball), userInfo: nil, repeats: false)
        }
    }
    //add star...............................................................................
    func addstar(){
        let positionX = Int(caveman.position.x + 1 - 42 / 84)
        let positionY = Int(caveman.position.x + 1 - 42 / 84)
        var didOccur = false
        var randomX = 0
        var randomY = 0
        
        while(!didOccur){
            randomX = Int(arc4random_uniform(16))
            randomY = Int(arc4random_uniform(9)+1)
            if (!matrix[randomY][randomX] && ((randomX != positionX) || (randomY != positionY)) ) {
                matrix[randomY][randomX] = true
                didOccur = true
            }
        }
     //   print(randomX.description + ", " + randomY.description)
        
        star.size = CGSize(width: 85, height: 85)
        star.physicsBody = SKPhysicsBody(circleOfRadius: star.frame.width / 2.5)
        star.position = CGPoint(x: 42.5 + Double(randomX) * 85.5  , y: 45 + Double(randomY) * 85)
        
        star.physicsBody?.affectedByGravity = false
        star.physicsBody?.isDynamic = false
        star.physicsBody?.categoryBitMask = PhysicsCategory.star
        star.physicsBody?.collisionBitMask = PhysicsCategory.none
        star.physicsBody?.contactTestBitMask = PhysicsCategory.caveman
        self.addChild(star)
        star.zPosition = 0.5
    }
    //add food...............................................................................
    @objc func addfood(){
        let positionX = Int(caveman.position.x + 1 - 42 / 84)
        let positionY = Int(caveman.position.x + 1 - 42 / 84)
        var didOccur = false
        var randomX = 0
        var randomY = 0
        
        while(!didOccur){
            randomX = Int(arc4random_uniform(16))
            randomY = Int(arc4random_uniform(9)+1)
            if (!matrix[randomY][randomX] && ((randomX != positionX) || (randomY != positionY)) ) {
                matrix[randomY][randomX] = true
                didOccur = true
            }
        }
       // print(randomX.description + ", " + randomY.description)
        
        food.size = CGSize(width: 85, height: 85)
        food.physicsBody = SKPhysicsBody(circleOfRadius: food.frame.width / 2.5)
        food.position = CGPoint(x: 42.5 + Double(randomX) * 85.5  , y: 45 + Double(randomY) * 85)
        
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.isDynamic = false
        food.physicsBody?.categoryBitMask = PhysicsCategory.food
        food.physicsBody?.collisionBitMask = PhysicsCategory.none
        food.physicsBody?.contactTestBitMask = PhysicsCategory.caveman | PhysicsCategory.dino1 | PhysicsCategory.dino2 | PhysicsCategory.dino3
        self.addChild(food)
        food.zPosition = 1.0
    }
    //add rock................................................................................
    @objc func addRock(){
        if (rockValue < 20){
            rockValue += 1
            rockLabel.text = rockValue.description
        }
    }
    //add energey................................................................................
    func batteryPower(point: Int){
        if (point < 0) {
            if (batteryValue > (point * -1)) {
                batteryValue += point
            } else if (batteryValue <= (point * -1)) && (heartValue > 1) {
                heartValue -= 1
                let nextlife = point + batteryValue
                batteryValue = 100 + nextlife
            } else if (batteryValue <= (point * -1)) && (heartValue == 1) {
                heartValue = 0
                batteryValue = 0
                caveman.removeFromParent()
                stutesLabel.text = "You ran out of life, Game Over!"
                self.run(SKAction.playSoundFileNamed("death", waitForCompletion: true))
                gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(endgame), userInfo: nil, repeats: false)
            }
        } else if (point > 0){
            if (batteryValue + point > 100 && heartValue < 3) {
                heartValue += 1
                let temp = batteryValue + point - 100
                batteryValue = temp
            } else if (batteryValue + point > 100 && heartValue == 3) {
                batteryValue = 100
            } else {
                batteryValue += point
            }
        }
        batteryLabel.text = batteryValue.description
        heartLabel.text = heartValue.description
    }
    @objc func changeBP(){
        batteryPower(point: -1)
        gameTime += 1
    }
    //add gravity................................................................................
    @objc func gravityTime() {
        if (gravity) {
            let i = Double(arc4random_uniform(20)+40)
            gravityTimer = Timer.scheduledTimer(timeInterval: i, target: self, selector: #selector(addGravity), userInfo: nil, repeats: false)
            gravity = false
        }
    }
    @objc func addGravity(){
        stutesLabel.text = "Gravity time is very close!"
        caveman.run(SKAction.sequence([
            SKAction.wait(forDuration: 3), SKAction.run( {self.caveman.physicsBody?.affectedByGravity = true} ), SKAction.wait(forDuration: 1),
                 SKAction.run( {self.caveman.physicsBody?.affectedByGravity = false} )]), completion: {self.stutesLabel.text = "Gravity time is over."})
        gravity = true
    }
    //Timer function....................................................................................
    func allTimer(){
        //set timer
        addblockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addRandBlock), userInfo: nil, repeats: true)
        if(addfire){
//            let i = Double(arc4random_uniform(UInt32(5)) + 5)
            addFireTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dropFireball), userInfo: nil, repeats: true)
        }
        addrockTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(addRock), userInfo: nil, repeats: true)
        
        gravityTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gravityTime), userInfo: nil, repeats: true)
        batteryTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeBP), userInfo: nil, repeats: true)

    }
    //End game function.................................................................................
    @objc func endgame(){
        // Save score (Pass data to 2nd scene)
        UserDefaults.standard.set(scoreValue, forKey: "currentScore")
        UserDefaults.standard.synchronize()
        
        addblockTimer.invalidate()
        batteryTimer.invalidate()
        addFireTimer.invalidate()
        addrockTimer.invalidate()
        gravityTimer.invalidate()
        
        self.removeAllActions()
        self.removeAllChildren()
        
        let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
        let gameOverScene = GameOverScene(size: self.size, score: scoreValue)
        gameOverScene.scaleMode = .aspectFill
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    //add Background to the view.............................................................
    func addBackGround(){
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        background.size = view!.frame.size
        self.addChild(background)
    }
    
}

//BitMask Category
struct PhysicsCategory{
    static let caveman: UInt32 = 0x1 << 1
    static let block: UInt32 = 0x1 << 2
    static let water: UInt32 = 0x1 << 3
    static let star: UInt32 = 0x1 << 4
    static let food: UInt32 = 0x1 << 5
    static let rock: UInt32 = 0x1 << 6
    static let fire: UInt32 = 0x1 << 7
    static let dino1: UInt32 = 0x1 << 8
    static let dino2: UInt32 = 0x1 << 9
    static let dino3: UInt32 = 0x1 << 10
    static let dino4: UInt32 = 0x1 << 11
    static let frame: UInt32 = 0x1 << 12
    static let none: UInt32 = 0x1 << 13
}
//CGPoint Math function
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

