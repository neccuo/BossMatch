import Foundation
import SpriteKit

// Update the enumeration to use the exact asset names
enum CardType {
    case attack
    case health
    case defense
    case dflt

    func getTextureName() -> String {
        switch self {
        case .attack:
            return "2_attack"
        case .health:
            return "2_health"
        case .defense:
            return "2_defense"
        case .dflt:
            return "default"
        }
    }

    static func random() -> CardType {
        return [CardType.attack, CardType.health, CardType.defense].randomElement()!
    }
}

class CardManager {
    var cards: [[Card]] = []
    var currentScene: SKScene? = nil
    var totalPowers: [CardType: Int] = [.attack: 0, .health: 0, .defense: 0]  // Track total powers for each type
    
    init(performingScene sceneIn: SKScene)
    {
        self.currentScene = sceneIn
        layCards(topLeft: CGPoint(x: -100, y: 200),
                 cardCounts: CGPoint(x: 4, y: 5),
                 // w + a, h + a
                 offsets: CGPoint(x: 60, y: 110))
        print("CardManager is initialized")
        displayTotalPowers()  // Initialize display of total powers
    }
    
    public func getCollidedCard(touchPos pos: CGPoint) -> Card? {
        for row in cards {
            for card in row {
                if card.checkCollision(atPoint: pos) {
                    updateTotalPower(card: card)  // Update power when a card is revealed
                    return card
                }
            }
        }
        return nil
    }
    
    private func layCards(topLeft orgPos: CGPoint, cardCounts countVec: CGPoint, offsets off: CGPoint) {
        for i in stride(from: 0, through: countVec.y-1, by: 1) {
            var cardRow: [Card] = []
            for j in stride(from: 0, through: countVec.x-1, by: 1) {
                let newCardPos: CGPoint = CGPoint(x: orgPos.x + (j * off.x), y: orgPos.y - (i * off.y))
                let randomType = CardType.random()  // Assign random type to each card
                let randomNumber = Int.random(in: 1...10)
                let card: Card = Card(cardPosition: newCardPos, type: randomType, value: randomNumber)
                card.setIndexCoors(i: Int(i), j: Int(j))
                card.activateCard(sceneToBeAdded: currentScene!)
                cardRow.append(card)
            }
            cards.append(cardRow)
        }
    }
    
    private func updateTotalPower(card: Card) {
        let type = card.getCardType() // Directly use the type without conditional binding
        totalPowers[type] = (totalPowers[type] ?? 0) + card.getCardValue()
        displayTotalPowers()  // Refresh display whenever total powers are updated
    }
    
    
    private func displayTotalPowers() {
        // Unique identifiers for the nodes
        let panelName = "powerPanel"
        let labelName = "powerLabel"
        
        // Update or create the background panel
        var powerPanel: SKSpriteNode!
        if let existingPanel = currentScene?.childNode(withName: panelName) as? SKSpriteNode {
            powerPanel = existingPanel
        } else {
            powerPanel = SKSpriteNode()
            powerPanel.name = panelName
            powerPanel.anchorPoint = CGPoint(x: 0.5, y: 0) // Centered horizontally, aligned to the bottom
            powerPanel.position = CGPoint(x: currentScene!.frame.midX, y: currentScene!.frame.minY + 250) // Raise the panel a bit above the bottom
            currentScene?.addChild(powerPanel)
        }
        
        // Update or create the power label
        var powerLabel: SKLabelNode!
        if let existingLabel = currentScene?.childNode(withName: "\(panelName)/\(labelName)") as? SKLabelNode {
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
        powerLabel.text = "\(attackIcon) Attack: \(totalPowers[.attack]!) \(healthIcon) Health: \(totalPowers[.health]!) \(defenseIcon) Defense: \(totalPowers[.defense]!)"
        
        // Animate the label to draw attention to the update
        powerLabel.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
    }
}
