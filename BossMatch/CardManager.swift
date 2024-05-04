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
    
    static func rngCard() -> CardType
    {
        // cumulative
        let chances : [Float] = [0.4, 0.8, 1.0]
        let rnd = Float.random(in: 0..<1)
        
        if rnd < chances[0]
        {
            return CardType.attack
        }
        else if chances[0] <= rnd && rnd < chances[1]
        {
            return CardType.health
        }
        else
        {
            return CardType.defense
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
        setupLevel()
        
        print("CardManager is initialized")
    }
    
    // called when init or to reset cards
    public func setupLevel()
    {
        deactivateCards()
        layCardsToMiddle(distFromMid: CGPoint(x: 0, y: 0),
                         cardCounts: CGPoint(x: 5, y: 7),
                         cardOffset: 10)
    }
    
    public func getCurrentScene() -> SKScene
    {
        return currentScene!
    }
    
    public func getCollidedCard(touchPos pos: CGPoint) -> Card? {
        for row in cards 
        {
            for card in row 
            {
                if card.checkCollision(atPoint: pos) 
                {
                    return card
                }
            }
        }
        return nil
    }
    
    private func layCardsToMiddle(distFromMid dist: CGPoint, cardCounts countVec: CGPoint, cardOffset off: CGFloat)
    {
        let frame = currentScene!.frame
        let cumCardWidth = countVec.x * (Card.width + off) - off
        let cumCardHeight = countVec.y * (Card.height + off) - off
        let screenBounds: CGSize = frame.size
        var screenOrigin: CGPoint = frame.origin
        // SK uses bottom left as origin, I want top left
        screenOrigin.y = -screenOrigin.y
        
        let alpha = (screenBounds.width - cumCardWidth) / 2
        let orgPosX = screenOrigin.x + (alpha + Card.width / 2)
        
        let beta = (screenBounds.height - cumCardHeight) / 2
        let orgPosY = screenOrigin.y - (beta + Card.height / 2)
        
        var origin : CGPoint = CGPoint(x: orgPosX, y: orgPosY)
        origin.x += dist.x
        origin.y += dist.y
        
        layCards(topLeft: origin, cardCounts: countVec, offset: off)
    }
    
    private func layCards(topLeft orgPos: CGPoint, cardCounts countVec: CGPoint, offset off: CGFloat) 
    {
        PosPrint.printPosition(orgPos)
        for i in stride(from: 0, through: countVec.y-1, by: 1) {
            var cardRow: [Card] = []
            for j in stride(from: 0, through: countVec.x-1, by: 1) {
                // let newCardPos: CGPoint = CGPoint(x: orgPos.x + (j * off.x), y: orgPos.y - (i * off.y))
                let newCardPos: CGPoint = CGPoint(x: orgPos.x + (j * (Card.width + off)),
                                                  y: orgPos.y - (i * (Card.height + off)))
                let randomType = CardType.rngCard()
                let randomNumber = Int.random(in: 1...10)
                let card: Card = Card(cardPosition: newCardPos, type: randomType, value: randomNumber)
                card.setIndexCoors(i: Int(i), j: Int(j))
                card.activateCard(sceneToBeAdded: currentScene!)
                cardRow.append(card)
            }
            cards.append(cardRow)
        }
    }
    
    private func deactivateCards()
    {
        for row in cards
        {
            for card in row
            {
                card.deactivateCard()
            }
        }
        cards = []
    }
    
}
