import SpriteKit
import GameplayKit

protocol GameSceneDelegate: class {
    func gameOver()
}

class GameScene: SKScene {
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    private var music: SKAction?
    private var mario : SKSpriteNode?
    private var marioWalking: SKAction?
    private var walkAction: SKAction?
    private var level : SKNode?
//    private var spinnyNode : SKShapeNode?
    
    let floorCategory: UInt32 = 0x1 << 0;
    let marioCategory: UInt32 = 0x1 << 1;
    let goombaCategory: UInt32 = 0x1 << 1;
    let goombaHeadCategory: UInt32 = 0x1 << 2;
    let flagCategory: UInt32 = 0x1 << 3;
    
    var marioIsJumping = false
    var marioIsDead = false
    
    
    override func update(_ currentTime: TimeInterval) {
        guard let mario = mario else { return }
        if (mario.position.y < -700 || mario.position.x < -350) && marioIsDead == false {
            killMario()
        }
    }
    
    
    func killMario() {
        stopAllEnemies()
        guard let mario = mario else { return }
        let music = mario.childNode(withName: "music")
        music?.run(SKAction.stop())
        marioIsDead = true
        mario.removeAllActions()
        mario.texture = SKTexture(imageNamed: "mario_dead")
        level?.removeAction(forKey: "levelScroller")
        mario.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 550))
        run(SKAction.playSoundFileNamed("dead", waitForCompletion: true), completion: { [weak self] in
            
            self?.gameSceneDelegate?.gameOver()
        })
    }
    
    func stopAllEnemies() {
        level?.childNode(withName: "Enemies")?.children.forEach({ goomba in
            goomba.removeAllActions()
        })
    }
    
//        }
//    }
    
    override func didMove(to view: SKView) {
        marioIsDead = false
        
        physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        self.mario = self.childNode(withName: "mario") as? SKSpriteNode
        self.mario?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mario?.frame.width ?? 0, height: mario?.frame.height ?? 0))
        self.mario?.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        self.mario?.physicsBody?.categoryBitMask = marioCategory
        self.mario?.physicsBody?.contactTestBitMask = floorCategory
        self.mario?.physicsBody?.collisionBitMask = floorCategory
        self.mario?.physicsBody?.allowsRotation = false
        
        self.level = self.childNode(withName: "level")
        self.level?.childNode(withName: "ground")?.children.forEach({ node in
            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.width, height: node.frame.height))
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = floorCategory
            node.physicsBody?.contactTestBitMask = marioCategory
            node.physicsBody?.collisionBitMask = marioCategory
        })
        makeMarioRun()
        level?.run(SKAction.repeatForever(SKAction.moveBy(x: -200.0, y: 0.0, duration: 1.0)), withKey: "levelScroller")
        
        level?.childNode(withName: "Enemies")?.children.forEach({ goomba in
            goomba.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "bad_guy_1"), SKTexture(imageNamed: "bad_guy_2")], timePerFrame: 1.0)))
            goomba.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: goomba.frame.width, height: goomba.frame.height))
            goomba.physicsBody?.allowsRotation = false
            goomba.physicsBody?.categoryBitMask = goombaCategory
            goomba.physicsBody?.contactTestBitMask = marioCategory | goombaCategory
            goomba.physicsBody?.collisionBitMask = floorCategory | marioCategory | goombaCategory
            
            goomba.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: -100.0, y: 0.0, duration: 10.0), SKAction.moveBy(x: 100.0, y: 0.0, duration: 10.0)])))
            
            let head = goomba.childNode(withName: "Head")
            head?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: head?.frame.width ?? 0, height: head?.frame.height ?? 0))
            head?.physicsBody?.allowsRotation = false
            head?.physicsBody?.pinned = true
            head?.physicsBody?.categoryBitMask = goombaHeadCategory
            head?.physicsBody?.collisionBitMask = marioCategory
            head?.physicsBody?.contactTestBitMask = marioCategory
           
            
        })
        
        let flag = level?.childNode(withName: "Scenery")?.childNode(withName: "Flag")
        flag?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: flag?.frame.width ?? 0, height: flag?.frame.height ?? 0))
        flag?.physicsBody?.allowsRotation = false
        flag?.physicsBody?.categoryBitMask = flagCategory
        flag?.physicsBody?.collisionBitMask = marioCategory
        flag?.physicsBody?.contactTestBitMask = marioCategory
        
    }
    
    
    
    func makeMarioRun() {
        marioWalking = SKAction(named: "mario_walking")
        
        walkAction = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "mario_walk_1"), SKTexture(imageNamed: "mario_walk_3"), SKTexture(imageNamed: "mario_walk_2")], timePerFrame: 0.09))
        
        mario?.run(walkAction!)
        
    }
    
    func makeMarioJump() {
        
        mario?.removeAllActions()
        mario?.texture = SKTexture(imageNamed: "mario_jump")
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if !marioIsJumping && !marioIsDead {
            let sound = SKAction.playSoundFileNamed("jump", waitForCompletion: true)
            run(sound)
            mario?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 400))
            marioIsJumping = true
            makeMarioJump()
        }
//        self.mario?.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
////        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
////        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
////        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    deinit{
        print("GameScene deinited")
        
    }
}

extension SKAction {
    /**
     * Performs an action after the specified delay.
     */
    class func afterDelay(_ delay: TimeInterval, performAction action: SKAction) -> SKAction {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }
    /**
     * Performs a block after the specified delay.
     */
    class func afterDelay(_ delay: TimeInterval, runBlock block: @escaping () -> Void) -> SKAction {
        return SKAction.afterDelay(delay, performAction: SKAction.run(block))
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if contact.bodyA.categoryBitMask == floorCategory && contact.bodyB.categoryBitMask == marioCategory && marioIsJumping {
            makeMarioRun()
            marioIsJumping = false
        }
        
        if contact.bodyA.categoryBitMask == marioCategory && contact.bodyB.categoryBitMask == goombaHeadCategory {
            print("Goomba Head")
            let goombaToKill = contact.bodyB.node?.parent
            goombaToKill?.physicsBody = nil
            let sound = SKAction.playSoundFileNamed("stomp", waitForCompletion: true)
            run(sound)
            goombaToKill?.run(SKAction.animate(with: [SKTexture(imageNamed: "bad_guy_3")], timePerFrame: 0.09), completion: {
                goombaToKill?.removeFromParent()
            })
        }
        
        if contact.bodyA.categoryBitMask == marioCategory && contact.bodyB.categoryBitMask == goombaCategory && marioIsDead == false {
            print("Goomba Kill")
            killMario()
        }
    }
}
