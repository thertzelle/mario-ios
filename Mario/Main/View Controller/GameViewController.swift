import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setup() {
        if let view = self.view as! SKView? {
            scene = SKScene(fileNamed: "GameScene") as? GameScene
            scene?.scaleMode = .aspectFill
            scene?.gameSceneDelegate = self
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
}

extension GameViewController: GameSceneDelegate {
    func gameOver() {
        print("Game Over!")
        setup()
    }
}
