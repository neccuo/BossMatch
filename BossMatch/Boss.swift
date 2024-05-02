//
//  Boss.swift
//  BossMatch
//
//  Created by Mobile Apps on 5/2/24.
//

import Foundation
import SpriteKit

class Boss
{
    private var attack : Int = -1
    private var health : Int = -1
    private var defense : Int = -1
    // image
    // card count on the field
    // card count allowed

    init(_ attackIn : Int, _ healthIn : Int, _ defenseIn : Int)
    {
        self.attack = attackIn
        self.health = healthIn
        self.defense = defenseIn
    }
    
    public func ATT() -> Int
    {
        return attack
    }
    
    public func HLT() -> Int
    {
        return health
    }
    
    public func DEF() -> Int
    {
        return defense
    }
    
    
}
