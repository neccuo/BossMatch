//
//  MatchManager.swift
//  BossMatch
//
//  Created by Mobile Apps on 5/4/24.
//

import Foundation
import SpriteKit

class MatchManager
{
    private var cachedCard : Card? = nil
    private var lock : Bool = false
    
    init()
    {
        print("MatchManager is initialized")
    }
    
    // ~~~ENTRY POINT FOR CARD INPUT~~~
    //  0>: for match, returns the total value from the match
    // -44: caught in lock
    //  00: if only one card is open;
    // -01: for no match
    public func match(card : Card) -> Int
    {
        if lock == true
        {
            return -44
        }
        if cachedCard == nil
        {
            onFirstCard(card: card)
            return 0
        }
        
        if cachedCard!.getCardType() == card.getCardType()
        {
            // guaranteed to be positive
            let totMatchVal = cachedCard!.getCardValue() + card.getCardValue()
            onMatch(card: card)
            return totMatchVal
        }
        else
        {
            onNoMatch(card: card)
            return -1
        }
    }
    
    private func onFirstCard(card : Card)
    {
        print("first card")
        card.setTextureFront(colorIn: SKColor.yellow)
        cachedCard = card
    }
    
    private func onMatch(card : Card)
    {
        print("match")
        card.setTextureFront(colorIn: SKColor.green)
        cachedCard!.setTextureFront(colorIn: SKColor.green)
        cachedCard = nil
    }
    
    private func onNoMatch(card : Card)
    {
        print("no match")
        card.setTextureFront(colorIn: SKColor.red)
        cachedCard!.setTextureFront(colorIn: SKColor.red)
        lock = true
        
        // Dispatch after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) 
        {
            card.setTextureBack()
            self.cachedCard!.setTextureBack()
            self.cachedCard = nil
            self.lock = false
        }
    }
}
