//
//  PlayViewController.swift
//  Day06
//
//  Created by Duy Anh on 1/17/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Utils
import CustomDrawing

class PlayViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageView: CustomUIImageView!        // Utils
    @IBOutlet var nameButtons: [CustomUIButton]!            // Utils
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!  // Custom Drawing
    
    var gameTimer: Timer?
    
    let dataModel = PlayModel()
    
    override func viewDidLoad() {
        dataModel.vc = self
        
        for button in nameButtons {
            button.addTarget(self, action: #selector(onClickAnswer(sender:)), for: .touchUpInside)
        }
        self.progressView.progressPercentage = 0
        
        newPokemon()
        startCounting()
    }
    
    func onClickAnswer(sender: UIButton) {
        dataModel.submitAnswer(sender.title(for: .normal)!)
        sender.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 120/255, blue: 104/255, alpha: 1)
        for button in nameButtons {
            if button.title(for: .normal) == dataModel.currentPokemon.name {
                button.backgroundColor = UIColor(colorLiteralRed: 142/255, green: 212/255, blue: 53/255, alpha: 1)
            }
        }
        nameLabel.isHidden = false
        imageView.blendAlpha = 0
        
        view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.newPokemon()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    func startCounting() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard self != nil else {
                timer.invalidate()
                return
            }
            if self!.dataModel.currentTime <= 0 {
                timer.invalidate()
                let ac = UIAlertController(title: "Time's up", message: "Score: \(self!.dataModel.score)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Okay", style: .default) { _ in
                    GameStats.shared.highScore = self!.dataModel.score
                    self!.performSegue(withIdentifier: "unwind", sender: nil)
                }
                ac.addAction(ok)
                self!.present(ac, animated: true)
                return
            }
            self!.dataModel.currentTime -= 1
            self!.progressView.progressPercentage = self!.dataModel.elapsedPercent
            self!.progressView.setNeedsDisplay()
        }
    }
    
    func newPokemon() {
        dataModel.getNewPokemon()
        
        for btn in nameButtons { btn.backgroundColor = .white }
        
        nameLabel.isHidden = true
        nameLabel.text = dataModel.currentPokemon.tag + "-" + dataModel.currentPokemon.name
        
        imageView.changeImage(UIImage(named: dataModel.currentPokemon.img)!)
        imageView.blendMode = 1
        imageView.blendColor = .black
        imageView.blendAlpha = 1
        
        view.backgroundColor = UIColor(dataModel.currentPokemon.color)
        
        for i in 0 ..< nameButtons.count {
            nameButtons[i].setTitle(dataModel.currentAnswers[i], for: .normal)
        }
    }
}
