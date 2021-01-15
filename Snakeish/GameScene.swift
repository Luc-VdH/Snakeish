//
//  GameScene.swift
//  Snakeish
//
//  Created by Luc Van Den Handel on 2021/01/04.
//

import SpriteKit
import CoreMotion


class GameScene: SKScene {
    
    var snake: SKSpriteNode!
    var motion = CMMotionManager()
    var score = 0
    var food: SKSpriteNode!
    var enemy: SKSpriteNode!
    let scoreLabel = SKLabelNode(text: "0")
    let gameOverLabel = SKLabelNode(text: "Game Over! Tap to Try Again")
    
    var gameOver = false
    
    override func didMove(to view: SKView) {
        layoutScene()
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom:self.frame)
        motion.startAccelerometerUpdates()
        motion.accelerometerUpdateInterval = 0.1
        motion.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            if self.gameOver == false{
                self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!)*10, dy: CGFloat((data?.acceleration.y)!)*10)
            }
        }
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.fontSize = frame.maxX/20
        gameOverLabel.fontName = "AvenirNext-Bold"
        spawnFood()
        spawnEnemy()
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        snake = SKSpriteNode(imageNamed: "snake")
        snake.size = CGSize(width: frame.size.width/5, height: frame.size.width/5)
        snake.position = CGPoint(x: frame.midX, y: frame.midY)
        snake.physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width/16)
        snake.physicsBody?.categoryBitMask = Physics.snakeCat
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 40.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.maxX-40, y: frame.maxY-40)
        
        addChild(scoreLabel)
        addChild(snake)
        
        
    }
    
    func spawnFood(){
        
        food = SKSpriteNode(imageNamed: "circle")
        food.size = CGSize(width: frame.size.width/10, height: frame.size.width/10)
        let maxX = frame.size.width - frame.size.width/12
        let maxY = frame.size.height - frame.size.width/12
        
        food.physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width/20)
        food.physicsBody?.categoryBitMask = Physics.foodCat
        food.physicsBody?.contactTestBitMask = Physics.snakeCat
        food.physicsBody?.collisionBitMask = Physics.none
        food.physicsBody?.isDynamic = false
        
        food.name = "food"
        
        
        food.position = CGPoint(x: CGFloat(Float.random(in: Float(frame.size.width/12)..<Float(maxX))), y: CGFloat(Float.random(in: Float(frame.size.width/12)..<Float(maxY))))
        
        
        addChild(food)
    }
    
    func spawnEnemy(){
        enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.size = CGSize(width: frame.size.width/10, height: frame.size.width/10)
        
        let maxX = frame.size.width - frame.size.width/12
        let maxY = frame.size.height - frame.size.width/12
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width/20)
        enemy.physicsBody?.categoryBitMask = Physics.foodCat
        enemy.physicsBody?.contactTestBitMask = Physics.snakeCat
        enemy.physicsBody?.collisionBitMask = Physics.none
        enemy.physicsBody?.isDynamic = false
        
        enemy.name = "enemy"
        
        
        enemy.position = CGPoint(x: CGFloat(Float.random(in: Float(frame.size.width/12)..<Float(maxX))), y: CGFloat(Float.random(in: Float(frame.size.width/12)..<Float(maxY))))
        
        addChild(enemy)
    }
    func updateScoreLabel(){
        scoreLabel.text = "\(score)"
    }
    
    override func update(_ currentTime: TimeInterval){
//        self.physicsWorld.gravity =
//            CGVector(dx: CGFloat(2.5*self.deviceMotion.gravity.x),
//                     dy: CGFloat(2.5*self.deviceMotion.gravity.y));
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver{
            score = 0
            scoreLabel.removeFromParent()
            snake.removeFromParent()
            layoutScene()
            enemy.removeFromParent()
            spawnEnemy()
            food.removeFromParent()
            spawnFood()
            gameOverLabel.removeFromParent()
            gameOver = false
            updateScoreLabel()
        }
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact){
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if gameOver == false{
            if contactMask == Physics.foodCat | Physics.snakeCat{
                if contact.bodyA.node?.name == "food" || contact.bodyB.node?.name == "food"{
                    score += 1
                    updateScoreLabel()
                    food.removeFromParent()
                    self.spawnFood()
                            
                    enemy.removeFromParent()
                    self.spawnEnemy()
                }else{
                    
                    addChild(gameOverLabel)
                    gameOver = true
                    
                
                }
            
        
            }else{
                score -= 1
                scoreLabel.text = "\(score)"
            }
        }
        
    }
}
