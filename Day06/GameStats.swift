
//
//  GameStats.swift
//  Day06
//
//  Created by Duy Anh on 1/18/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation
class GameStats: NSObject {
    static var shared = GameStats()
    var highScore: Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "HIGH_SCORE")
        }
    }
    var playTime: Int = 30
    
    dynamic var selectedGenerations: [Int] {
        didSet {
            UserDefaults.standard.set(selectedGenerations, forKey: "SELECTED_GENERATIONS")
        }
    }
    
    dynamic var musicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(musicEnabled, forKey: "MUSIC")
        }
    }
    
    dynamic var effectsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(effectsEnabled, forKey: "EFFECTS")
        }
    }
    
    override init() {
        self.highScore = UserDefaults.standard.integer(forKey: "HIGH_SCORE")
        self.selectedGenerations = UserDefaults.standard.array(forKey: "SELECTED_GENERATIONS") as? [Int] ?? [1]
        self.musicEnabled = UserDefaults.standard.object(forKey: "MUSIC") as? Bool ?? true
        self.effectsEnabled = UserDefaults.standard.object(forKey: "EFFECTS") as? Bool ?? true
        super.init()
    }
}
