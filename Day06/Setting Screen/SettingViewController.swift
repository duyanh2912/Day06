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
    
    override func viewDidLoad() {
        GameStats.shared.addObserver(self, forKeyPath: #keyPath(GameStats.selectedGenerations), options: .initial, context: nil)
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
            if selectedGen.count == 1 { return }
            selectedGen.remove(at: index)
        } else {
            selectedGen.append(sender.tag)
        }
        GameStats.shared.selectedGenerations = selectedGen
    }
}
