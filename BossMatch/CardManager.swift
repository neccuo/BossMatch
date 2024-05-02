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
    private var cards: [[Card]] = []
    private var currentScene: SKScene? = nil
    
    init(performingScene sceneIn: SKScene)
    {
        self.currentScene = sceneIn
        layCards(topLeft: CGPoint(x: -100, y: 200),
                 cardCounts: CGPoint(x: 4, y: 5),
                 // w + a, h + a
                 offsets: CGPoint(x: 60, y: 110))
        print("CardManager is initialized")
    }
    
    public func getCurrentScene() -> SKScene
    {
        return currentScene!
    }
    
    public func getCollidedCard(touchPos pos: CGPoint) -> Card? {
        for row in cards {
            for card in row {
                if card.checkCollision(atPoint: pos) {
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
    
    
}
