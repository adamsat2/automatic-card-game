//
//  GameViewController.swift
//  card-game
//

import UIKit

class GameViewController: UIViewController, CallBackTimer {
    
    @IBOutlet weak var left_name_lbl: UILabel!
    @IBOutlet weak var round_lbl: UILabel!
    @IBOutlet weak var right_name_lbl: UILabel!
    @IBOutlet weak var roundres_lbl: UILabel!
    
    @IBOutlet weak var continue_btn: UIButton!
    
    @IBOutlet weak var left_card_img: UIImageView!
    @IBOutlet weak var right_card_img: UIImageView!
    
    var name: String = ""
    var currentRound: Int = 1
    var gameTimer = TimeCounter(interval: 3.0)
    var plyScore: Int = 0
    var comScore: Int = 0
    var isGameOver: Bool = false
    var isPlayerOnLeft: Bool = true
    
    let roundsNumber: Int = 10
    let cardsNames: [String] = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    let suits: [String] = ["Spades", "Clubs", "Hearts", "Diamonds"]
    
    func updateSideNames() {
        if isPlayerOnLeft {
            left_name_lbl.text = "\(name) (\(plyScore))"
            right_name_lbl.text = "House (\(comScore))"
        } else {
            left_name_lbl.text = "House (\(comScore))"
            right_name_lbl.text = "\(name) (\(plyScore))"
        }
    }
    
    func updateSideImages(plyCard: String, comCard: String) {
        if isPlayerOnLeft {
            left_card_img.image = UIImage(named: plyCard)
            right_card_img.image = UIImage(named: comCard)
        } else {
            left_card_img.image = UIImage(named: comCard)
            right_card_img.image = UIImage(named: plyCard)
        }
    }
    
    func updateRoundResult(status: Int, cardIndex: Int, suitIndex: Int) {
        if status == 0 {
            self.roundres_lbl.text = "Tie! Both drew a \(self.cardsNames[cardIndex])!"
        } else {
            let winnerName = status == 1 ? self.name : "House"
            self.roundres_lbl.text = "\(winnerName) wins with a \(self.cardsNames[cardIndex]) of \(self.suits[suitIndex])!"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gameTimer.delegate = self
        
        updateSideNames()
        round_lbl.text = "Round: \(currentRound)"
        roundres_lbl.text = "Starting game..."
    }
    
    func startTimer() {
        gameTimer.start()
    }
    
    func tickDetected() {
        let plyIndex = Int.random(in: 0..<self.cardsNames.count)
        let compIndex = Int.random(in: 0..<self.cardsNames.count)
        
        let plySuit = Int.random(in: 0..<self.suits.count)
        let compSuit = Int.random(in: 0..<self.suits.count)
        
        let plyCardImage = "\(self.cardsNames[plyIndex].lowercased())_\(self.suits[plySuit].lowercased())"
        let compCardImage = "\(self.cardsNames[compIndex].lowercased())_\(self.suits[compSuit].lowercased())"
        
        updateSideImages(plyCard: plyCardImage, comCard: compCardImage)
        
        if plyIndex > compIndex {
            self.plyScore += 1
            updateRoundResult(status: 1, cardIndex: plyIndex, suitIndex: plySuit)
        } else if compIndex > plyIndex {
            self.comScore += 1
            updateRoundResult(status: -1, cardIndex: compIndex, suitIndex: compSuit)
        } else {
            self.roundres_lbl.text = "Tie! Both drew a \(self.cardsNames[plyIndex])!"
        }
        
        updateSideNames()
        
        if self.currentRound < self.roundsNumber {
            self.currentRound += 1
            self.round_lbl.text = "Round: \(self.currentRound)"
        } else {
            self.isGameOver = true
            self.gameTimer.stop()
            self.continue_btn.isEnabled = true
            self.round_lbl.text = "Game Over"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ScoreViewController {
            if plyScore > comScore {
                destination.name = self.name
                destination.score = self.plyScore
            } else {
                destination.name = "The House"
                destination.score = self.comScore
            }
        }
    }
    
    // stop the timer when leaving the app
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer.stop()
    }
    
    // continue the timer when returning to the app if game isn't over
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isGameOver {
            startTimer()
        }
    }
    
}
