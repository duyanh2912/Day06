//
//  SettingViewController.swift
//  Day06
//
//  Created by Duy Anh on 1/25/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet var generationButtons: [UIButton]!
    @IBOutlet weak var effectSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    override func viewDidLoad() {
        GameStats.shared.addObserver(self, forKeyPath: #keyPath(GameStats.selectedGenerations), options: .initial, context: nil)
        effectSwitch.isOn = GameStats.shared.effectsEnabled
        musicSwitch.isOn = GameStats.shared.musicEnabled
    }
    
    deinit {
        GameStats.shared.removeObserver(self, forKeyPath: #keyPath(GameStats.selectedGenerations))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        for btn in generationButtons {
            if GameStats.shared.selectedGenerations.index(of: btn.tag) == nil {
                btn.alpha = 0.5
            } else {
                btn.alpha = 1
            }
        }
    }
    
    @IBAction func tappedGenerationButton(_ sender: UIButton) {
        var selectedGen = GameStats.shared.selectedGenerations
        if let index = selectedGen.index(of: sender.tag) {
            if selectedGen.count == 1 {
                SoundManager.shared.incorrect.play()
                return
            }
            selectedGen.remove(at: index)
        } else {
            selectedGen.append(sender.tag)
        }
        SoundManager.shared.toggle.play()
        GameStats.shared.selectedGenerations = selectedGen
    }
    
    
    @IBAction func effectsSwitched(_ sender: UISwitch) {
        GameStats.shared.effectsEnabled = sender.isOn
        SoundManager.shared.toggle.play()
    }
    
    @IBAction func musicSwitched(_ sender: UISwitch) {
        GameStats.shared.musicEnabled = sender.isOn
        SoundManager.shared.toggle.play()
    }
}
