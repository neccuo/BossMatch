//
//  BossManager.swift
//  BossMatch
//
//  Created by Mobile Apps on 5/2/24.
//

import Foundation
import SpriteKit

class BossManager
{
    private var currBoss : Boss = Boss(20, 50, 10)
    
    init()
    {
        print("BossManager is initialized")
    }
    
    public func getBoss() -> Boss
    {
        return currBoss
    }
    
    public func simulateBossFight(_ pAtt : Int, _ pHea : Int, _ pDef : Int)
    {
        // apply defense stats. cannot exceed 80
        // reduce attack based on defense
        let bossFinAtt = self.calculateFinalAttackValue(currBoss.ATT(), pDef)
        let playerFinAtt = self.calculateFinalAttackValue(pAtt, currBoss.DEF())
        
        // how many turn the character needs to kill its opponent
        let bossTurnToKill = calculateTurnToKillCount(bossFinAtt, pHea)
        let playerTurnToKill = calculateTurnToKillCount(playerFinAtt, currBoss.HLT())
        
        // end states
        if bossTurnToKill > playerTurnToKill
        {
            print("player won")
        }
        else if bossTurnToKill < playerTurnToKill
        {
            print("boss won")
        }
        else
        {
            print("stalemate")
        }
    }
    
    private func calculateFinalAttackValue(_ myAttack : Int, _ oppDefense : Int) -> Int
    {
        let val = Double(myAttack) * (1.0 - min(Double(oppDefense) / 100.0, 0.8))
        return Int(ceil(val))
    }
    
    private func calculateTurnToKillCount(_ myAttack : Int, _ oppHealth : Int) -> Int
    {
        return oppHealth / myAttack + (oppHealth % myAttack == 0 ? 0 : 1)
    }
}
