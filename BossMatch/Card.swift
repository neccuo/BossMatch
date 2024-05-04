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
    private var isButtonEnabled : Bool = true
    
    // only for debugging
    private var indexCoors : CGPoint = CGPoint(x : -1, y : -1)
    
    private var backCardTex : SKTexture = SKTexture(imageNamed: "back_card")
    // no such thing called front_card
    private var frontCardTex : SKTexture = SKTexture(imageNamed: "front_card")
    
    private var cardType : CardType? = nil
    private var cardValue : Int = 0
    
    static var width : CGFloat = 50.0
    static var height : CGFloat = 100.0
    
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
        cardButton = SKSpriteNode(texture: nil, size: CGSize(width: Card.width, height: Card.height))
        cardButton.position = pos
        self.cardType = cardType
        self.frontCardTex = SKTexture(imageNamed: self.cardType!.getTextureName())
        self.cardValue = cardValue
        // sets the texture
        setTextureBack()
//        print("Card is initialized.")
    }
    
    public func checkCollision(atPoint pos : CGPoint) -> Bool
    {
        return cardButton.contains(pos) && self.isButtonEnabled
    }
    
    // add to a scene
    public func activateCard(sceneToBeAdded scene: SKScene)
    {
        scene.addChild(self.cardButton)
//        print("Card is activated")
    }
    
    public func deactivateCard()
    {
        self.cardButton.removeFromParent()
    }
    
    func setColor(colorIn : SKColor)
    {
        let cardButtonSKNode = cardButton as! SKSpriteNode
        cardButtonSKNode.color = colorIn
    }
    
    func setTextureBack()
    {
        let cardButtonSKNode = cardButton as! SKSpriteNode
        
        cardButtonSKNode.color = SKColor.white
        cardButtonSKNode.colorBlendFactor = 1.0
        cardButtonSKNode.texture = backCardTex
        
        self.isButtonEnabled = true
    }
    
    func setTextureFront(colorIn : SKColor = SKColor.white)
    {
        let cardButtonSKNode = cardButton as! SKSpriteNode
        
        cardButtonSKNode.color = colorIn
        cardButtonSKNode.colorBlendFactor = 0.8
        cardButtonSKNode.texture = frontCardTex
        
        self.isButtonEnabled = false
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
            "card at index coor (\(indexCoors.x), \(indexCoors.y) and " +
            "pos (x: \(cardButton.position.x), y: \(cardButton.position.y))"
            )
    }
    
    
}
