//
//  Card.swift
//  BossMatch
//
//  Created by Mobile Apps on 4/22/24.
//

import Foundation
import SpriteKit


class Card
{
    private var cardButton : SKNode! = nil
    
    // only for debugging
    private var indexCoors : CGPoint = CGPoint(x : -1, y : -1)
    
    convenience init()
    {
        self.init(cardPosition : CGPoint(x : 100, y : 100))
    }
    
    init(cardPosition pos : CGPoint)
    {
        cardButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 50, height: 100))
        cardButton.position = pos
        print("Card is initialized.")
    }
    
    public func checkCollision(atPoint pos : CGPoint) -> Bool
    {
        return cardButton.contains(pos)
    }
    
    // add to a scene
    public func activateCard(sceneToBeAdded scene: SKScene)
    {
        scene.addChild(self.cardButton)
        print("Card is activated")
    }
    
    public func deactivateCard()
    {
        self.cardButton.removeFromParent()
    }
    
    func setColor(colorIn : UIColor)
    {
        let cardButtonSKNode = cardButton as! SKSpriteNode
        cardButtonSKNode.color = colorIn
    }
    
    func setIndexCoors(i : Int, j : Int)
    {
        indexCoors = CGPoint(x : i, y : j)
    }
    
    func getIndexCoors() -> CGPoint
    {
        return indexCoors
    }
    
    func printCard()
    {
        print(
            "card at index coor (\(indexCoors.x), \(indexCoors.y) and" +
            "pos (x: \(cardButton.position.x), y: \(cardButton.position.y))"
            )
    }
    
    
}
