//
//  CardManager.swift
//  BossMatch
//
//  Created by Mobile Apps on 4/23/24.
//

import Foundation
import SpriteKit

class CardManager
{
    var cards : [[Card]] = []
    var currentScene : SKScene? = nil
    
    init(performingScene sceneIn : SKScene)
    {
        self.currentScene = sceneIn
        layCards(topLeft: CGPoint(x: -100, y: 200),
                 cardCounts: CGPoint(x: 4, y: 5),
                 // w + a, h + a
                 offsets: CGPoint(x: 110, y: 210))
        print("CardManager is initialized")
    }
    
    public func getCollidedCard(touchPos pos : CGPoint) -> Card?
    {
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
    
    private func layCards(topLeft orgPos : CGPoint, cardCounts countVec : CGPoint, offsets off : CGPoint)
    {
        for i in stride(from: 0, through: countVec.y-1, by: 1)
        {
            var cardRow : [Card] = []
            for j in stride(from: 0, through: countVec.x-1, by: 1)
            {
                let newCardPos : CGPoint = CGPoint(x: orgPos.x + (j * off.x), y: orgPos.y - (i * off.y))
                let card : Card = Card(cardPosition: newCardPos)
                card.setIndexCoors(i: Int(i), j: Int(j))
                card.activateCard(sceneToBeAdded: currentScene!)
                cardRow.append(card)
            }
            cards.append(cardRow)
        }
    }
}
