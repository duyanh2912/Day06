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
import RxSwift
import RxCocoa

class PlayModel: NSObject {
    var allPokemonsID: [Int]!
    var selectedPokemonsID: [Int] = []
    
    var currentAnswers: [String] = []
    var currentPokemon: Variable<Pokemon> = Variable(Pokemon())
    
    var currentTime = Variable<CGFloat>(CGFloat(GameStats.shared.playTime))
    var elapsedPercent: Observable<CGFloat>!
    var score = Variable(0)
    var dbm: DatabaseManager { return DatabaseManager.shared }
    
    var disposeBag = DisposeBag()
    
    deinit {
        print("Deinit-PlayModel")
    }
    
    override init() {
        super.init()
        setUpReactive()
        allPokemonsID = dbm.getPokemonIDs(generations: GameStats.shared.selectedGenerations)
    }
    
    func setUpReactive() {
        elapsedPercent = currentTime
            .asObservable()
            .map {
                (1 - CGFloat($0) / CGFloat(GameStats.shared.playTime))*100
        }
    }
    
    func getNewPokemon() {
        currentAnswers.removeAll()
        
        let ids = (0...3).map {_ in
            getValueFrom({ allPokemonsID.randomMember }, notIncludedIn: selectedPokemonsID)
        }
        
        ids.forEach { id in
            selectedPokemonsID.append(id)
            currentAnswers.append(dbm.nameOfPokemon(id: id)!)
        }
        
        currentAnswers = currentAnswers.randomizedArray
        currentPokemon.value = dbm.getPokemon(id: ids[0])!
    }
    
    func submitAnswer(_ name: String) -> Bool {
        if name == currentPokemon.value.name {
            score.value += 1
            return true
        }
        return false
    }
}
