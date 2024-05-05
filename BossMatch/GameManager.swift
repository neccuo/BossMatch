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
    private var matchManager : MatchManager
    private var pTotalPowers : [CardType: Int] = [.attack: 1, .health: 1, .defense: 0]
    
    // it should give you a result of a potential fight with your current stats and the boss stats
    private var simulateFightButton : SKNode? = nil
    private var godModeButton : SKNode? = nil
    
    private var currentLevel : Int = 0

    init(cardScreenScene cardScene : SKScene)
    {
        self.cardManager = CardManager(performingScene : cardScene)
        self.bossManager = BossManager()
        self.matchManager = MatchManager()
        
        // set UI
        displayPTotalPowers(self.cardManager.getCurrentScene())
        
        self.setLevel(level : currentLevel)


        print("GameManager is initialized")
    }
    
    public func touchCard(atPos pos : CGPoint) // -> Bool
    {
        let card = cardManager.getCollidedCard(touchPos: pos)
        if card != nil
        {
            print("Touched a card with the value \(card!.getCardValue()).")

            let matchResult = matchManager.match(card: card!)
            
            // there is a match or false match
            if matchResult > 0 || matchResult == -1
            {
                displayMatchAvailable(cardManager.getCurrentScene())
                
                if matchResult > 0
                {
                    updateTotalPower(cardType: card!.getCardType(), cardIncValue: matchResult)
                }
            }
            // no available matches left
            if matchManager.getAvailableMatch() <= 0
            {
                let fightButton = self.simulateFightButton as! SKSpriteNode
                fightButton.color = SKColor.green
            }
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
            if(res > 0)
            {
                // next level
                currentLevel += 1
                setLevel(level: currentLevel)
            }
            else
            {
                // reset level
                setLevel(level : currentLevel)
            }
        }
        else if self.godModeButton != nil && self.godModeButton!.contains(pos)
        {
            updateTotalPower(totalPowers: [.attack: 999, .health: 999, .defense: 80])
        }
    }
    
    private func setLevel(level : Int)
    {
        // total powers may remain the same or reset????
        bossManager.setBossByLevel(level: level)
        cardManager.setCardsByLevel(level: level)
        matchManager.setAvailableMatchByLevel(level: level)
        // boss updates as well
        
        // update UI
        updateTotalPower(totalPowers: [.attack: 1, .health: 1, .defense: 0])
        displayLevel(cardManager.getCurrentScene())
        displayMatchAvailable(cardManager.getCurrentScene())
        setButtons()
    }
        
    private func updateTotalPower(cardType type : CardType, cardIncValue value : Int)
    {
        pTotalPowers[type] = (pTotalPowers[type] ?? 0) + value
        self.setTotalPowerUI()
    }
    
    private func updateTotalPower(totalPowers pow : [CardType: Int])
    {
        pTotalPowers = pow
        self.setTotalPowerUI()
    }
    
    private func updateTotalPower(card: Card) 
    {
        let type = card.getCardType() // Directly use the type without conditional binding
        pTotalPowers[type] = (pTotalPowers[type] ?? 0) + card.getCardValue()
        self.setTotalPowerUI()
    }
    
    private func setTotalPowerUI()
    {
        displayPTotalPowers(self.cardManager.getCurrentScene())
    }
    
    private func displayMatchAvailable(_ scene: SKScene)
    {
        let labelName = "matchCountLabel"
        
        var matchCountLabel: SKLabelNode!
        if let existingLabel = scene.childNode(withName: "\(labelName)") as? SKLabelNode
        {
            matchCountLabel = existingLabel
        }
        else
        {
            matchCountLabel = SKLabelNode(fontNamed: "YourCustomFont")
            matchCountLabel.name = labelName
            matchCountLabel.verticalAlignmentMode = .center
            matchCountLabel.position = CGPoint(x: scene.frame.minX + 225, y: scene.frame.maxY - 200)
            
            scene.addChild(matchCountLabel)
        }
        
        matchCountLabel.text = "Allowed Match Count: \(matchManager.getAvailableMatch())"
        matchCountLabel.fontSize = 24
    }
    
    private func displayLevel(_ scene: SKScene)
    {
        let panelName = "levelPanel"
        let labelName = "levelLabel"
        
        var levelPanel: SKSpriteNode!
        if let existingPanel = scene.childNode(withName: panelName) as? SKSpriteNode
        {
            levelPanel = existingPanel
        }
        else
        {
            levelPanel = SKSpriteNode()
            levelPanel.name = panelName
            levelPanel.anchorPoint = CGPoint(x: 0.5, y: 1) // aligned to the top
            levelPanel.position = CGPoint(x: scene.frame.minX + 150, y: scene.frame.maxY - 100)
            scene.addChild(levelPanel)
        }
        
        var levelLabel: SKLabelNode!
        if let existingLabel = scene.childNode(withName: "\(panelName)/\(labelName)") as? SKLabelNode {
            levelLabel = existingLabel
        } else {
            levelLabel = SKLabelNode(fontNamed: "YourCustomFont")
            levelLabel.name = labelName
            levelLabel.verticalAlignmentMode = .center
            levelLabel.position = CGPoint(x: 0, y: 0)
            
            levelPanel.addChild(levelLabel)
        }
        
        levelLabel.text = "Level: \(self.currentLevel)"
    }
    
    private func displayPTotalPowers(_ scene: SKScene) {
        // Unique identifiers for the nodes
        let panelName = "powerPanel"
        let labelName = "powerLabel"
        let bossLabelName = "bossPowerLabel"
        
        // Update or create the background panel
        var powerPanel: SKSpriteNode!
        if let existingPanel = scene.childNode(withName: panelName) as? SKSpriteNode {
            powerPanel = existingPanel
        } else {
            powerPanel = SKSpriteNode()
            powerPanel.name = panelName
            powerPanel.anchorPoint = CGPoint(x: 0.5, y: 0) // Centered horizontally, aligned to the bottom
            powerPanel.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY + 200) // Raise the panel a bit above the bottom
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
        
        var bossPowerLabel: SKLabelNode!
        if let existingLabel = scene.childNode(withName: "\(panelName)/\(bossLabelName)") as? SKLabelNode {
            bossPowerLabel = existingLabel
        } else {
            bossPowerLabel = SKLabelNode(fontNamed: "YourCustomFont") // Replace "YourCustomFont" with your font
            bossPowerLabel.name = bossLabelName
            bossPowerLabel.verticalAlignmentMode = .center // Vertically centered within the panel
            bossPowerLabel.position = CGPoint(x: 0, y: -75) // Centered in the panel
            
            powerPanel.addChild(bossPowerLabel)  // Add label to panel instead of scene
        }
        
        // Set or update the label text with icons
        let attackIcon = "⚔️" // Use custom icons here
        let healthIcon = "❤️"
        let defenseIcon = "🛡"
        powerLabel.text = "\(attackIcon) Attack: \(pTotalPowers[.attack]!) \(healthIcon) Health: \(pTotalPowers[.health]!) \(defenseIcon) Defense: \(pTotalPowers[.defense]!)"
        
        let boss = bossManager.getBoss()
        
        bossPowerLabel.text = "\(attackIcon) Attack: \(boss.ATT()) \(healthIcon) Health: \(boss.HLT()) \(defenseIcon) Defense: \(boss.DEF())"
        
        bossPowerLabel.fontColor = SKColor.red
    }
    
    private func setButtons()
    {
        self.simulateFightButton = SKSpriteNode(color : UIColor.yellow, size: CGSize(width: 100, height: 50))
        self.simulateFightButton!.position = CGPoint(x: 250, y: 450)
        cardManager.getCurrentScene().addChild(simulateFightButton!)
        
        self.godModeButton = SKSpriteNode(color : UIColor.cyan, size: CGSize(width: 50, height: 25))
        self.godModeButton!.position = CGPoint(x: 250, y: 350)
        cardManager.getCurrentScene().addChild(godModeButton!)
        print("Buttons are activated")
    }
    
}
