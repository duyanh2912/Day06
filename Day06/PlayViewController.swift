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
    @IBOutlet var nameButtons: [CustomUIButton]!            // Utils
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!  // Custom Drawing
    
    @IBOutlet weak var cardHolderView: UIView!
    @IBOutlet weak var cardHolderCenterConstraint: NSLayoutConstraint!
    
    var gameTimer: Timer?
    
    var frontImage: UIImageView = UIImageView(image: nil)
    var backImage: UIImageView! = UIImageView(image: nil)
    
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
        
        UIView.transition(from: frontImage, to: backImage, duration: 0.5, options: .transitionFlipFromLeft) { [unowned self] _ in
            self.cardHolderView.sendSubview(toBack: self.backImage)
            self.nameLabel.isHidden = false
            
            self.view.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
            
            for btn in self.nameButtons { btn.isHidden = true }
        
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: { [weak self] in
                guard self != nil else { return }
                self!.cardHolderCenterConstraint.constant = -self!.view.frame.width / 2 - self!.cardHolderView.frame.width / 2
                self?.view.layoutIfNeeded()
            }) {
                [weak self] _ in guard self != nil else { return }
                
                self?.newPokemon()
                self?.cardHolderCenterConstraint.constant = self!.view.frame.width / 2 + self!.cardHolderView.frame.width / 2
                self?.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self?.cardHolderCenterConstraint.constant = 0
                    self?.view.layoutIfNeeded()
                }) { [weak self] _ in guard self != nil else { return }
                    self?.view.isUserInteractionEnabled = true
                    for btn in self!.nameButtons { btn.isHidden = false }
                }
            }   
        }
    }
    
    func setupImage() {
        for sub in cardHolderView.subviews where sub !== nameLabel { sub.removeFromSuperview() }
        frontImage.image = UIImage(named: dataModel.currentPokemon.img)!.withRenderingMode(.alwaysTemplate)
        frontImage.frame = CGRect(origin: .zero, size: cardHolderView.frame.size)
        frontImage.tintColor = .black
        frontImage.backgroundColor = .white
        frontImage.contentMode = .scaleAspectFit
        
        backImage.image = UIImage(named: dataModel.currentPokemon.img)
        backImage.frame = CGRect(origin: .zero, size: cardHolderView.frame.size)
        backImage.backgroundColor = .white
        backImage.contentMode = .scaleAspectFit
        
        cardHolderView.addSubview(frontImage)
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
        
        view.backgroundColor = UIColor(dataModel.currentPokemon.color)
        
        for i in 0 ..< nameButtons.count {
            nameButtons[i].setTitle(dataModel.currentAnswers[i], for: .normal)
        }
        setupImage()
    }
}
