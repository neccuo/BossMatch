//
//  GameManager.swift
//  BossMatch
//
//  Created by Mobile Apps on 4/23/24.
//

import Foundation
import SpriteKit

// Entry point for the game
class GameManager
{
    private var cardManager : CardManager
    private var bossManager : BossManager
    private var pTotalPowers : [CardType: Int] = [.attack: 1, .health: 1, .defense: 0]
    
    // it should give you a result of a potential fight with your current stats and the boss stats
    private var simulateFightButton : SKNode? = nil

    init(cardScreenScene cardScene : SKScene)
    {
        self.cardManager = CardManager(performingScene : cardScene)
        self.bossManager = BossManager()
        
        // set UI
        displayPTotalPowers(self.cardManager.getCurrentScene())
        setButtons()

        print("GameManager is initialized")
    }
    
    public func initLevel()
    {
        // total powers remain the same
        updateTotalPower(totalPowers: [.attack: 1, .health: 1, .defense: 0])
        cardManager.setupLevel()
        bossManager.nextLevel()
    }
    
    public func touchCard(atPos pos : CGPoint) // -> Bool
    {
        let card = cardManager.getCollidedCard(touchPos: pos)
        if card != nil
        {
            card?.setTextureFront()
//            card?.printCard()
            updateTotalPower(card: card!)
            print("Opened a card with the value \(card!.getCardValue()).")
        }
    }
    
    public func touchButton(atPos pos : CGPoint) // -> Bool
    {
        if self.simulateFightButton != nil && self.simulateFightButton!.contains(pos)
        {
            let res = bossManager.simulateBossFight(pTotalPowers[.attack]!,
                                          pTotalPowers[.health]!,
                                          pTotalPowers[.defense]!)
            print("Bossfight result: \(res)")
            initLevel()
        }
    }
    
    private func updateTotalPower(totalPowers pow : [CardType: Int])
    {
        pTotalPowers = pow
        setTotalPowerUI()
    }
    
    private func updateTotalPower(card: Card) 
    {
        let type = card.getCardType() // Directly use the type without conditional binding
        pTotalPowers[type] = (pTotalPowers[type] ?? 0) + card.getCardValue()
        setTotalPowerUI()
    }
    
    private func setTotalPowerUI()
    {
        displayPTotalPowers(self.cardManager.getCurrentScene())
    }
    
    private func displayPTotalPowers(_ scene: SKScene) {
        // Unique identifiers for the nodes
        let panelName = "powerPanel"
        let labelName = "powerLabel"
        
        // Update or create the background panel
        var powerPanel: SKSpriteNode!
        if let existingPanel = scene.childNode(withName: panelName) as? SKSpriteNode {
            powerPanel = existingPanel
        } else {
            powerPanel = SKSpriteNode()
            powerPanel.name = panelName
            powerPanel.anchorPoint = CGPoint(x: 0.5, y: 0) // Centered horizontally, aligned to the bottom
            powerPanel.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY + 100) // Raise the panel a bit above the bottom
            scene.addChild(powerPanel)
        }
        
        // Update or create the power label
        var powerLabel: SKLabelNode!
        if let existingLabel = scene.childNode(withName: "\(panelName)/\(labelName)") as? SKLabelNode {
            powerLabel = existingLabel
        } else {
            powerLabel = SKLabelNode(fontNamed: "YourCustomFont") // Replace "YourCustomFont" with your font
            powerLabel.name = labelName
            powerLabel.verticalAlignmentMode = .center // Vertically centered within the panel
            powerLabel.position = CGPoint(x: 0, y: 0) // Centered in the panel
            powerPanel.addChild(powerLabel)  // Add label to panel instead of scene
        }
        
        // Set or update the label text with icons
        let attackIcon = "⚔️" // Use custom icons here
        let healthIcon = "❤️"
        let defenseIcon = "🛡"
        powerLabel.text = "\(attackIcon) Attack: \(pTotalPowers[.attack]!) \(healthIcon) Health: \(pTotalPowers[.health]!) \(defenseIcon) Defense: \(pTotalPowers[.defense]!)"
        
        // Animate the label to draw attention to the update
        powerLabel.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
    }
    
    private func setButtons()
    {
        self.simulateFightButton = SKSpriteNode(color : UIColor.red, size: CGSize(width: 100, height: 50))
        self.simulateFightButton!.position = CGPoint(x: 250, y: 450)
        
        cardManager.getCurrentScene().addChild(simulateFightButton!)
        print("Button is activated")
    }
    
}
