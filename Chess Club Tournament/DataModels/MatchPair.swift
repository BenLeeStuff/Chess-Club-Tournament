//
//  Matchup.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import Foundation

class MatchPair {
    
    var player1: Player?
    var player2: Player?
    var pair: [Player]?
    var matchComplete: Bool?
    var draw: Bool?
    
    var winner: Player?
    var loser: Player?
    
    init(player1: Player?, player2: Player?, players: [Player]?, matchComplete: Bool?, winner: Player?, loser: Player?, draw: Bool?) {
        
        self.player1 = player1 as? Player ?? Player(name: nil, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: nil, totalLosses: nil, totalDraws: nil, totalScore: nil, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
        self.player2 = player2 ?? Player(name: nil, boardColor: nil, didWin: nil, didLose: nil, didDraw: nil, place: nil, totalWins: nil, totalLosses: nil, totalDraws: nil, totalScore: nil, scores: nil, previousColor: nil, lastPlayed: nil, opponentsPlayed: nil, isSittingOut: false)
        self.pair = [self.player1, self.player2] as! [Player] ?? []
        self.matchComplete = matchComplete ?? false
        self.winner = winner
        self.loser = loser
        self.draw = draw
    }
    
}
