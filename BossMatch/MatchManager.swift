//
//  MatchManager.swift
//  BossMatch
//
//  Created by Mobile Apps on 5/4/24.
//

import Foundation

class MatchManager
{
    var cachedCard : Card? = nil
    
    public func match(card : Card)
    {
        if cachedCard == nil
        {
            cachedCard = card
            return
        }
    }
}
