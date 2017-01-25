//
//  ViewController.swift
//  Day06
//
//  Created by Duy Anh on 1/15/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        scoreLabel.text = GameStats.shared.highScore.description
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.shared.playMusic.stop()
        SoundManager.shared.menuMusic.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SoundManager.shared.click.play()
    }
    
    @IBAction func unwindToBase(segue: UIStoryboardSegue) {
        SoundManager.shared.click.play()
    }
}

