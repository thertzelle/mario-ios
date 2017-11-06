import SpriteKit

protocol LevelDelegate: class {
    func reset()
}

class Level: SKNode {
    
    weak var levelDelegate: LevelDelegate?
    
    public func setup() {
        childNode(withName: "ground")?.children.forEach({ node in
            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.width, height: node.frame.height))
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = Categories.floorCategory
            node.physicsBody?.contactTestBitMask = Categories.marioCategory
            node.physicsBody?.collisionBitMask = Categories.marioCategory
        })
        
        startScrolling()
        setupEnemies()
        setupFlag()
    }
    
    private func startScrolling() {
        run(SKAction.repeatForever(SKAction.moveBy(x: -200.0, y: 0.0, duration: 1.0)), withKey: "levelScroller")
    }
    
    public func stopScrolling() {
        let flag = childNode(withName: "Scenery")?.childNode(withName: "Flag")
        flag?.physicsBody = nil
        removeAction(forKey: "levelScroller")
    }
    
    public func completeLevel() {
        self.run(SKAction.moveBy(x: -385.0, y: 0.0, duration: 1.5)) { [weak self] in
            self?.levelDelegate?.reset()
        }
    }
    
    private func setupEnemies() {
        childNode(withName: "Enemies")?.children.forEach({ goomba in
            goomba.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "bad_guy_1"), SKTexture(imageNamed: "bad_guy_2")], timePerFrame: 1.0)))
            goomba.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: goomba.frame.width, height: goomba.frame.height))
            goomba.physicsBody?.allowsRotation = false
            goomba.physicsBody?.categoryBitMask = Categories.goombaCategory
            goomba.physicsBody?.contactTestBitMask = Categories.marioCategory | Categories.goombaCategory
            goomba.physicsBody?.collisionBitMask = Categories.floorCategory | Categories.marioCategory | Categories.goombaCategory
            
            goomba.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: -100.0, y: 0.0, duration: 10.0), SKAction.moveBy(x: 100.0, y: 0.0, duration: 10.0)])))
            
            let head = goomba.childNode(withName: "Head")
            head?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: head?.frame.width ?? 0, height: head?.frame.height ?? 0))
            head?.physicsBody?.allowsRotation = false
            head?.physicsBody?.pinned = true
            head?.physicsBody?.categoryBitMask = Categories.goombaHeadCategory
            head?.physicsBody?.collisionBitMask = Categories.marioCategory
            head?.physicsBody?.contactTestBitMask = Categories.marioCategory
            
            
        })
    }
    
    private func setupFlag() {
        let flag = childNode(withName: "Scenery")?.childNode(withName: "Flag")
        flag?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: flag?.frame.width ?? 0, height: flag?.frame.height ?? 0))
        flag?.physicsBody?.allowsRotation = false
        flag?.physicsBody?.categoryBitMask = Categories.flagCategory
        flag?.physicsBody?.collisionBitMask = Categories.floorCategory
        flag?.physicsBody?.contactTestBitMask = Categories.floorCategory | Categories.marioCategory
    }

}
