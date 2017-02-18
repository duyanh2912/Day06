//
//  PlayViewController.swift
//  Day06
//
//  Created by Duy Anh on 1/17/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//
import RxSwift
import RxCocoa
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
    var sig: Observable<Float>!
    
    var frontImage: UIImageView = UIImageView(image: nil)
    var backImage: UIImageView! = UIImageView(image: nil)
    
    let dataModel = PlayModel()
    var disposeBag = DisposeBag()
    
    deinit {
        print("Deinit-PlayViewController")
    }
    
    override func viewDidLoad() {
        setUpButton()
        
        newPokemon()
        startCounting()
        
        setUpScoreView()
        setUpProgressView()
        setUpPokemon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SoundManager.shared.menuMusic.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.shared.playMusic.play()
    }
    
    func setUpButton() {
        nameButtons.forEach { (btn: UIButton) in
            btn.rx
                .tap
                .subscribe(onNext: { [weak self] in
                    self?.onClickAnswer(sender: btn)
                })
                .addDisposableTo(disposeBag)
        }
    }
    
    func setUpScoreView() {
        dataModel
            .score
            .asObservable()
            .map { $0.description }
            .bindTo(scoreLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    func onClickAnswer(sender: UIButton) {
        SoundManager.shared.click.play()
        self.view.isUserInteractionEnabled = false
        
        if dataModel.submitAnswer(sender.title(for: .normal)!) == true {
            SoundManager.shared.correct.play()
        } else {
            SoundManager.shared.incorrect.play()
        }
        
        sender.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 120/255, blue: 104/255, alpha: 1)
        for button in nameButtons {
            if button.title(for: .normal) == dataModel.currentPokemon.value.name {
                button.backgroundColor = UIColor(colorLiteralRed: 142/255, green: 212/255, blue: 53/255, alpha: 1)
            }
        }
        
        backImage.frame = frontImage.frame
        
        UIView.transition(from: frontImage, to: backImage, duration: 0.5, options: .transitionFlipFromLeft) { [unowned self] _ in
            self.cardHolderView.sendSubview(toBack: self.backImage)
            self.nameLabel.isHidden = false
            
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
    
    func setupImage(_ pokemon: Pokemon) {
        for sub in cardHolderView.subviews where sub !== nameLabel { sub.removeFromSuperview() }
        frontImage.image = UIImage(named: pokemon.img)!.withRenderingMode(.alwaysTemplate)
        frontImage.tintColor = .black
        frontImage.backgroundColor = .white
        frontImage.contentMode = .scaleAspectFit
        frontImage.cornerRadius = 20
        frontImage.translatesAutoresizingMaskIntoConstraints = false
        
        backImage.image = UIImage(named: pokemon.img)
        backImage.backgroundColor = .white
        backImage.contentMode = .scaleAspectFit
        backImage.cornerRadius = 20
        
        cardHolderView.addSubview(frontImage)
        frontImage.createAnchorsToFitWith(other: cardHolderView)
    }
    
    func setUpProgressView() {
        dataModel
            .elapsedPercent
            .asObservable()
            .bindTo(progressView
                .rx
                .percent)
            .addDisposableTo(disposeBag)
    }
    
    func setUpPokemon() {
        dataModel.currentPokemon.asObservable()
            .subscribe(onNext: { [unowned self] pkm in
                self.setUpLabel(pkm)
                self.setupImage(pkm)
            })
            .addDisposableTo(disposeBag)
    }
    
    func startCounting() {
        let interval: Double = 0.2
        
        let timer = Observable<Int>.interval(interval, scheduler: ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self]_ in
                self?.dataModel.currentTime.value -= CGFloat(interval)
            })
            .do(onDispose: { [weak self] in
                let ac = UIAlertController(title: "Time's up", message: "Score: \(self!.dataModel.score.value)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Okay", style: .default) { _ in
                    SoundManager.shared.click.play()
                    GameStats.shared.highScore = self!.dataModel.score.value
                    self?.performSegue(withIdentifier: "unwind", sender: nil)
                }
                ac.addAction(ok)
                self?.present(ac, animated: true)
            })
            .subscribe()
        
        dataModel.currentTime
            .asObservable()
            .subscribe(onNext: {
                if $0 <= 0 { timer.dispose() }
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func setUpLabel(_ pokemon: Pokemon) {
        nameButtons.forEach { $0.backgroundColor = .white }
        
        nameLabel.isHidden = true
        nameLabel.text = pokemon.tag + "-" + pokemon.name
        
        view.backgroundColor = UIColor(pokemon.color)
        
        for i in 0 ..< nameButtons.count {
            nameButtons[i].setTitle(dataModel.currentAnswers[i], for: .normal)
        }
    }
    
    func newPokemon() {
        dataModel.getNewPokemon()
    }
    
    @IBAction func clickedBackButton(_ sender: UIButton) {
        SoundManager.shared.click.play()
    }
}


