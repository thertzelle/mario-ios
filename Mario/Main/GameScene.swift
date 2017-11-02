import SpriteKit
import GameplayKit

protocol GameSceneDelegate: class {
    func gameOver()
}

class GameScene: SKScene {
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    private var mario : SKSpriteNode?
    private var marioWalking: SKAction?
    private var walkAction: SKAction?
    private var ground : SKNode?
//    private var spinnyNode : SKShapeNode?
    
    let floorCategory: UInt32 = 0x1 << 0;
    let marioCategory: UInt32 = 0x1 << 1;
    
    var marioIsJumping = false
    
    
    override func update(_ currentTime: TimeInterval) {
//        self.mario?.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        if mario!.position.y < -700 {
            gameSceneDelegate?.gameOver()
        }
    }
//        }
//    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        self.mario = self.childNode(withName: "mario") as? SKSpriteNode
        self.mario?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mario?.frame.width ?? 0, height: mario?.frame.height ?? 0))
        self.mario?.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        self.mario?.physicsBody?.categoryBitMask = marioCategory
        self.mario?.physicsBody?.contactTestBitMask = floorCategory
        self.mario?.physicsBody?.collisionBitMask = floorCategory
        self.mario?.physicsBody?.allowsRotation = false
        
        self.ground = self.childNode(withName: "ground")
        self.ground?.children.forEach({ node in
            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.width, height: node.frame.height))
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = floorCategory
            node.physicsBody?.contactTestBitMask = marioCategory
            node.physicsBody?.collisionBitMask = marioCategory
        })
//        self.ground?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground?.frame.width ?? 0, height: ground?.frame.height ?? 0))
//        self.ground?.physicsBody?.affectedByGravity = false
//        self.ground?.physicsBody?.isDynamic = false
        makeMarioRun()
        ground?.run(SKAction.repeatForever(SKAction.moveBy(x: -200.0, y: 0.0, duration: 1.0)))
        
    }
    
    
    
    func makeMarioRun() {
        marioWalking = SKAction(named: "mario_walking")
        
        walkAction = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "mario_walk_1"), SKTexture(imageNamed: "mario_walk_2"), SKTexture(imageNamed: "mario_walk_3")], timePerFrame: 0.09))
        
        mario?.run(walkAction!)
        
    }
    
    func makeMarioJump() {
        marioIsJumping = true
        mario?.removeAllActions()
        mario?.texture = SKTexture(imageNamed: "mario_jump")
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        mario?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        makeMarioJump()
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
        if marioIsJumping {
            makeMarioRun()
        }
    }
}
