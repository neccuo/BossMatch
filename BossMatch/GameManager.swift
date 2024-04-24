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
    init(cardScreenScene cardScene : SKScene)
    {
        self.cardManager = CardManager(performingScene : cardScene)

        setBossManager()
        print("GameManager is initialized")
    }
    
    public func getTouchedCard(atPos pos : CGPoint) -> Card?
    {
        return cardManager.getCollidedCard(touchPos: pos)
    }
    
    
    func setBossManager()
    {
        print("Boss Manager is set")
    }
    
}
