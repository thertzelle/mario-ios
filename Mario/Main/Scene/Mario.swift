import SpriteKit

protocol MarioDelegate: class {
    func playJumpSound()
    func scrollLevelToCompletion()
}

final class Mario: SKSpriteNode {
    
    public var marioIsJumping = false
    public var marioIsDead = false
    
    public var marioWalking: SKAction?
    
    weak var marioDelegate: MarioDelegate?
    
    public func setup() {
        marioIsDead = false
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height))
        physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        physicsBody?.categoryBitMask = Categories.marioCategory
        physicsBody?.contactTestBitMask = Categories.floorCategory
        physicsBody?.collisionBitMask = Categories.floorCategory
        physicsBody?.allowsRotation = false
    }
    
    public func walk() {
        marioWalking = SKAction(named: "mario_walking")
        run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "mario_walk_1"), SKTexture(imageNamed: "mario_walk_3"), SKTexture(imageNamed: "mario_walk_2")], timePerFrame: 0.09)))
    }
    
    public func jump() {
        func jumpAnimation() {
            removeAllActions()
            texture = SKTexture(imageNamed: "mario_jump")
        }
        
        if !marioIsJumping && !marioIsDead {
            marioDelegate?.playJumpSound()
            physicsBody?.applyImpulse(CGVector(dx: 0, dy: 400))
            marioIsJumping = true
            jumpAnimation()
        }
    }
    
    public func stop() {
        stopMusic()
        marioIsDead = true
        removeAllActions()
        texture = SKTexture(imageNamed: "mario_jump")
        run(SKAction.moveBy(x: 150.0, y: 0.0, duration: 2.0))
        run(SKAction.playSoundFileNamed("clear", waitForCompletion: true), completion: { [weak self] in
            self?.marioDelegate?.scrollLevelToCompletion()
            self?.walk()
            self?.run(SKAction.moveBy(x: 500.0, y: 0.0, duration: 2.0))
        })
    }
    
    public func performDeath() {
        stopMusic()
        marioIsDead = true
        removeAllActions()
        texture = SKTexture(imageNamed: "mario_dead")
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 550))
    }
    
    public func shouldDie() {
        if (position.y < -700 || position.x < -350) && marioIsDead == false {
            stopMusic()
            marioIsDead = true
            removeAllActions()
            texture = SKTexture(imageNamed: "mario_dead")
            physicsBody?.applyImpulse(CGVector(dx: 0, dy: 550))
        }
    }
    
    private func stopMusic() {
        childNode(withName: "music")?.run(SKAction.stop())
    }
}

