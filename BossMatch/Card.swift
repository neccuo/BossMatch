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
    
    private var backCardTex : SKTexture = SKTexture(imageNamed: "back_card")
    private var frontCardTex : SKTexture = SKTexture(imageNamed: "front_card")
    
    private var cardType : CardType? = nil
    private var cardValue : Int = 0
    
    convenience init()
    {
        self.init(cardPosition : CGPoint(x : 100, y : 100))
    }
    
    convenience init(cardPosition pos : CGPoint)
    {
        self.init(cardPosition : pos, type : CardType.dflt, value : 1)
    }
    
    init(cardPosition pos : CGPoint, type cardType : CardType, value cardValue : Int)
    {
        cardButton = SKSpriteNode(texture: self.backCardTex, size: CGSize(width: 50, height: 100))
        cardButton.position = pos
        self.cardType = cardType
        self.frontCardTex = SKTexture(imageNamed: self.cardType!.getTextureName())
        self.cardValue = cardValue
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
    
    func setTextureFront()
    {
        let cardButtonSKNode = cardButton as! SKSpriteNode
        cardButtonSKNode.texture = frontCardTex
    }
    
    func setIndexCoors(i : Int, j : Int)
    {
        indexCoors = CGPoint(x : i, y : j)
    }
    
    func getIndexCoors() -> CGPoint
    {
        return indexCoors
    }
    
    func getCardType() -> CardType
    {
        return cardType!
    }
    
    func getCardValue() -> Int
    {
        return cardValue
    }
    
    func printCard()
    {
        print(
            "card at index coor (\(indexCoors.x), \(indexCoors.y) and" +
            "pos (x: \(cardButton.position.x), y: \(cardButton.position.y))"
            )
    }
    
    
}
