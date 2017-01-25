//
//  StateController.swift
//  Day06
//
//  Created by Duy Anh on 1/17/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//
import Utils
import GameplayKit
import Foundation

class PlayModel: NSObject {
    var allPokemonsID: [Int]!
    var selectedPokemonsID: [Int] = []
    
    var currentAnswers: [String] = []
    var currentPokemon: Pokemon!
    
    var currentTime = GameStats.shared.playTime
    var elapsedPercent: CGFloat {
        return (1 - CGFloat(currentTime) / CGFloat(GameStats.shared.playTime))*100
    }
    dynamic var score = 0
    var dbm: DatabaseManager { return DatabaseManager.shared }
    
    override init() {
        super.init()
        allPokemonsID = dbm.getPokemonIDs(generations: GameStats.shared.selectedGenerations)
    }
    
    func getNewPokemon() {
        currentAnswers.removeAll()
        currentPokemon = nil
        
        var id = allPokemonsID.randomMember
        while selectedPokemonsID.contains(id) {
            id = allPokemonsID.randomMember
        }
        selectedPokemonsID.append(id)
        currentPokemon = dbm.getPokemon(id: id)
        
        currentAnswers.append(currentPokemon.name)
        
        for _ in 0 ... 2 {
            var index = allPokemonsID.randomMember
            while currentAnswers.contains(dbm.nameOfPokemon(id: index)!) {
                index = allPokemonsID.randomMember
            }
            currentAnswers.append(dbm.nameOfPokemon(id: index)!)
        }
        currentAnswers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: currentAnswers) as! [String]
    }
    
    func submitAnswer(_ name: String) -> Bool {
        if name == currentPokemon.name {
            score += 1
            return true
        }
        return false
    }
}
