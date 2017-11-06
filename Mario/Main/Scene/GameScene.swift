import SpriteKit
import GameplayKit

protocol GameSceneDelegate: class {
    func gameOver()
}

struct Categories {
    static let floorCategory: UInt32 = 0x1 << 1;
    static let marioCategory: UInt32 = 0x1 << 2;
    static let goombaCategory: UInt32 = 0x1 << 3;
    static let goombaHeadCategory: UInt32 = 0x1 << 4;
    static let flagCategory: UInt32 = 0x1 << 5;
}

class GameScene: SKScene {
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    private var mario : Mario?
    private var level : Level?

    override func update(_ currentTime: TimeInterval) {
        mario?.shouldDie()
    }
    
    func killMario() {
        stopAllEnemies()
        level?.stopScrolling()
        mario?.performDeath()
        run(SKAction.playSoundFileNamed("dead", waitForCompletion: true), completion: { [weak self] in
            self?.gameSceneDelegate?.gameOver()
        })
    }
    
    func winSequence() {
        level?.stopScrolling()
        mario?.stop()
    }
    
    func stopAllEnemies() {
        level?.childNode(withName: "Enemies")?.children.forEach({ goomba in
            goomba.removeAllActions()
        })
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        self.mario = self.childNode(withName: "mario") as? Mario
        self.mario?.setup()
        self.mario?.marioDelegate = self
        
        self.level = self.childNode(withName: "level") as? Level
        self.level?.setup()
        self.level?.levelDelegate = self
        
        self.mario?.walk()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        mario?.jump()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    deinit {
        print("GameScene deinited")
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == Categories.marioCategory && contact.bodyB.categoryBitMask == Categories.floorCategory && mario?.marioIsJumping ?? false && !(mario?.marioIsDead ?? false) {
            print("Touching the Ground!")
            mario?.walk()
            mario?.marioIsJumping = false
        }
        
        if contact.bodyA.categoryBitMask == Categories.marioCategory && contact.bodyB.categoryBitMask == Categories.goombaHeadCategory {
            print("Goomba Head")
            let goombaToKill = contact.bodyB.node?.parent
            goombaToKill?.physicsBody = nil
            run(SKAction.playSoundFileNamed("stomp", waitForCompletion: true))
            goombaToKill?.run(SKAction.animate(with: [SKTexture(imageNamed: "bad_guy_3")], timePerFrame: 0.09), completion: {
                goombaToKill?.removeFromParent()
            })
        }
        
        if contact.bodyA.categoryBitMask == Categories.marioCategory && contact.bodyB.categoryBitMask == Categories.goombaCategory && !(mario?.marioIsDead ?? false) {
            print("Goomba Kill")
            killMario()
        }
        
        if contact.bodyA.categoryBitMask == Categories.marioCategory && contact.bodyB.categoryBitMask == Categories.flagCategory {
            print("Win Sequence")
            winSequence()
        }
    }
}

extension GameScene: MarioDelegate {
    func scrollLevelToCompletion() {
        level?.completeLevel()
    }

    func playJumpSound() {
        run(SKAction.playSoundFileNamed("jump", waitForCompletion: true))
    }
}

extension GameScene: LevelDelegate {
    func reset() {
        gameSceneDelegate?.gameOver()
    }
}
