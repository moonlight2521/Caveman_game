//
//  GameOverScene.swift
//  MazeMan
//
//  Created by Zun Lin on 4/10/18.
//  Copyright © 2018 Zun Lin. All rights reserved.
//
import UIKit
import SpriteKit

class GameOverScene: SKScene {

    var highScore = Scores()
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GameOver!"
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Your score is \(score) !"
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        // transition to game over scene
        let flipTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        self.view?.presentScene(newScene, transition: flipTransition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let highScore = Scores()
        let currentScore = UserDefaults.standard.integer(forKey: "currentScore")
        if let savedScore = UserDefaults.standard.object(forKey: "scoresInfo") as? NSData {
            let scores = NSKeyedUnarchiver.unarchiveObject(with: savedScore as Data) as? Scores
            highScore.set(scores: scores!.get())
        }
        
        highScore.add(score: currentScore)
        let scoreData = NSKeyedArchiver.archivedData(withRootObject: highScore)
        UserDefaults.standard.set(scoreData, forKey: "scoresInfo")
        
        var HS = ""
        let i = highScore.scores.count
        if (i > 3) {
            HS = "\(highScore.scores[i-1]) , \(highScore.scores[i-2]) , \(highScore.scores[i-3])"
        } else if (i == 2) {
            HS = "\(highScore.scores[i-1]) , \(highScore.scores[i-2])"
        } else if( i == 1) {
            HS = "\(highScore.scores[i-1])"
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = "High Score is: \(HS)"
        highScoreLabel.fontSize = 30
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        self.addChild(highScoreLabel)
        
        let beginLabel = SKLabelNode(fontNamed: "Chalkduster")
        beginLabel.text = "Tab to begin a new game"
        beginLabel.fontSize = 30
        beginLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(beginLabel)
    }
    
}
//Scores Class
class Scores: NSObject, NSCoding {
    
    var scores = [Int]()

    func encode(with aCoder: NSCoder) {
        aCoder.encode(scores, forKey: "scores")
    }
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.scores = (aDecoder.decodeObject(forKey: "scores") as? [Int])!
    }
    //append
    func add(score: Int) {
        scores.append(score)
        scores.sort()
    }
    //setter
    func set(scores: [Int]) {
        for i in scores {
            self.add(score: i)
        }
    }
    //getter
    func get() -> [Int] {
        return scores
    }
}
