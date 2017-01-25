//
//  StateController.swift
//  Day06
//
//  Created by Duy Anh on 1/17/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//
import GameplayKit
import Foundation

class PlayModel {
    weak var vc: PlayViewController!
    
    var selectedPokemonsID: [Int] = []
    var currentAnswers: [String] = []
    var currentPokemon: Pokemon!
    
    var currentTime = GameStats.shared.playTime
    var elapsedPercent: CGFloat {
        return (1 - CGFloat(currentTime) / CGFloat(GameStats.shared.playTime))*100
    }
    
    var score = 0 {
        didSet {
            vc.scoreLabel.text = score.description
        }
    }
    
    var dbm = DatabaseManager.shared
    
    func getNewPokemon() {
        currentAnswers.removeAll()
        currentPokemon = nil
        
        var id = Int(arc4random_uniform(UInt32(dbm.numberOfPokemons))) + 1
        while selectedPokemonsID.contains(id) {
            id = Int(arc4random_uniform(UInt32(dbm.numberOfPokemons))) + 1
        }
        selectedPokemonsID.append(id)
        currentPokemon = dbm.getPokemon(id: id)
        
        currentAnswers.append(currentPokemon.name)
        
        for _ in 0 ... 2 {
            var index = Int(arc4random_uniform(UInt32(dbm.numberOfPokemons))) + 1
            while currentAnswers.contains(dbm.nameOfPokemon(id: index)!) {
                index = Int(arc4random_uniform(UInt32(dbm.numberOfPokemons))) + 1
            }
            currentAnswers.append(dbm.nameOfPokemon(id: index)!)
        }
        currentAnswers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: currentAnswers) as! [String]
    }
    
    func submitAnswer(_ name: String) {
        if name == currentPokemon.name {
            score += 1
        }
    }
}
