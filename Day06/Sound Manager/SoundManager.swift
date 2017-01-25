//
//  SoundManager.swift
//  Day06
//
//  Created by Duy Anh on 1/25/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()
    var click: AVAudioPlayer! { return createEffects("UIClick", "wav") }
    var toggle: AVAudioPlayer! { return createEffects("UIToggle", "wav") }
    var correct: AVAudioPlayer! { return createEffects("firered_00FA", "wav") }
    var incorrect: AVAudioPlayer! { return createEffects("firered_00A3", "wav") }
    
    var menuMusic: AVAudioPlayer!
    var playMusic: AVAudioPlayer!
    
    var music: [AVAudioPlayer]!
    var effects: [AVAudioPlayer]!
    
    override init() {
        super.init()

        self.menuMusic = createMusic("Quirky-Puzzle-Game-Menu","mp3")
        self.playMusic = createMusic("8-Bit-Mayhem","mp3")
        
        self.effects = []
        self.music = [menuMusic, playMusic]
        
        for audio in music { audio.numberOfLoops = -1 }
        
        GameStats.shared.addObserver(self, forKeyPath: #keyPath(GameStats.musicEnabled), options: .initial, context: nil)
        GameStats.shared.addObserver(self, forKeyPath: #keyPath(GameStats.effectsEnabled), options: .initial, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if GameStats.shared.effectsEnabled == true {
            for audio in effects { audio.volume = 1 }
        } else { for audio in effects { audio.volume = 0 }}
        
        if GameStats.shared.musicEnabled == true {
            for audio in music { audio.volume = 1 }
        } else { for audio in music { audio.volume = 0 }}
    }
    
    deinit {
        GameStats.shared.removeObserver(self, forKeyPath: #keyPath(GameStats.musicEnabled))
        GameStats.shared.removeObserver(self, forKeyPath: #keyPath(GameStats.effectsEnabled))
    }
    
    func createEffects(_ soundName: String, _ ext: String) -> AVAudioPlayer {
        let audio = createMusic(soundName, ext)
        effects.append(audio)
        audio.delegate = self
        if GameStats.shared.effectsEnabled == false { audio.volume = 0 }
        return audio
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = effects.index(of: player) {
            effects.remove(at: index)
        }
    }
    
    func createMusic(_ soundName: String, _ ext: String) -> AVAudioPlayer {
        let url = Bundle.main.url(forResource: soundName, withExtension: ext)
        let audio = try! AVAudioPlayer(contentsOf: url!)
        return audio
    }
}
