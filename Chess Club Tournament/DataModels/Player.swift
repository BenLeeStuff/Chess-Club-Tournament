//
//  Player.swift
//  Chess Club Tournament
//
//  Created by Ben Lee on 1/30/19.
//  Copyright © 2019 Ben Lee. All rights reserved.
//

import Foundation

class Player {
    var name: String?
    var boardColor: String?
    var didWin: Bool?
    var place: Int?
    var totalWins: Int?
    var totalLosses: Int?
    var totalDraws: Int?
    var totalScore: Double?
    var scores: [Double]?
    var previousColor: String?
    var lastPlayed: String?
    var opponentsPlayed: [String]?
    var isSittingOut: Bool?
    var isWaiting: Bool?
    var timesSatOut: Int?
    
    init(name: String?, boardColor: String?, didWin: Bool?, didLose: Bool?, didDraw: Bool?, place: Int?, totalWins: Int?, totalLosses: Int?, totalDraws: Int?, totalScore: Double?, scores: [Double]?, previousColor: String?, lastPlayed: String?, opponentsPlayed: [String]?, isSittingOut: Bool?, isWaiting: Bool?, timesSatOut: Int?) {
        self.name = name as? String ?? ""
        self.boardColor = boardColor as? String ?? "none"
        self.didWin = didWin as? Bool ?? false
        self.place = place as? Int ?? 0
        self.totalWins = totalWins as? Int ?? 0
        self.totalLosses = totalLosses as? Int ?? 0
        self.totalScore = totalScore as? Double ?? 0
        self.scores = scores as? [Double] ?? []
        self.previousColor = previousColor as? String ?? "none"
        self.lastPlayed = lastPlayed as? String ?? "none"
        self.opponentsPlayed = opponentsPlayed as? [String] ?? []
        self.totalDraws = totalDraws as? Int ?? 0
        self.isSittingOut = isSittingOut
        self.isWaiting = isWaiting
        self.timesSatOut = timesSatOut
    }
}
