//
//  GameScene.swift
//  BossMatch
//
//  Created by Mobile Apps on 4/22/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
//    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var gameManager : GameManager? = nil

    // Entry point
    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        self.gameManager = GameManager(cardScreenScene: self)
    }
    
    // called by touchesBegan
    func touchDown(atPoint pos : CGPoint) {
        PosPrint.printPosition(pos)
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        // checks all
        gameManager?.touchCard(atPos: pos)
        gameManager?.touchButton(atPos: pos)
    }
    
    // calls touch down
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    // calls touch moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    // calls touchUp
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { 
            self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // calls touchUp
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
