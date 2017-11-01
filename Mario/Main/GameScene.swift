import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var mario : SKSpriteNode?
    private var marioWalking: SKAction?
    private var ground : SKSpriteNode?
//    private var spinnyNode : SKShapeNode?
    
    
    override func update(_ currentTime: TimeInterval) {
        self.mario?.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
    }
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.mario = self.childNode(withName: "mario") as? SKSpriteNode
        self.mario?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mario?.frame.width ?? 0, height: mario?.frame.height ?? 0))
        
        self.ground = self.childNode(withName: "ground") as? SKSpriteNode
        self.ground?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground?.frame.width ?? 0, height: ground?.frame.height ?? 0))
        self.ground?.physicsBody?.affectedByGravity = false
        self.ground?.physicsBody?.isDynamic = false
        
        self.marioWalking = SKAction(named: "mario_walking")
        
        
        
        let walkAciton = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "mario_2"), SKTexture(imageNamed: "mario_3"), SKTexture(imageNamed: "mario_4")], timePerFrame: 0.00003))
        
        mario?.run(walkAciton)
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        mario?.physicsBody?.applyForce(CGVector(dx: 0, dy: 200))
        self.mario?.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
