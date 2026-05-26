//
//  GameViewController.swift
//  card-game
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var round_lbl: UILabel!
    @IBOutlet weak var com_lbl: UILabel!
    @IBOutlet weak var roundres_lbl: UILabel!
    
    @IBOutlet weak var continue_btn: UIButton!
    
    @IBOutlet weak var plycard_img: UIImageView!
    @IBOutlet weak var compcard_img: UIImageView!
    
    var name: String = ""
    var currentRound: Int = 1
    var gameTimer : Timer?
    var plyScore: Int = 0
    var comScore: Int = 0
    var isGameOver: Bool = false
    
    let roundTime: Int = 2
    let roundsNumber: Int = 5
    let cardsNames: [String] = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    let suits: [String] = ["Spades", "Clubs", "Hearts", "Diamonds"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name_lbl.text = "\(name) (\(plyScore))"
        com_lbl.text = "House (\(comScore))"
        round_lbl.text = "Round: \(currentRound)"
        roundres_lbl.text = "Starting game..."
    }
    
    func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in  guard let self = self else { return }
            let playerIndex = Int.random(in: 0..<self.cardsNames.count)
            let computerIndex = Int.random(in: 0..<self.cardsNames.count)
            
            let playerSuit = Int.random(in: 0..<self.suits.count)
            let computerSuit = Int.random(in: 0..<self.suits.count)
            
            let playerCardImage = "\(self.cardsNames[playerIndex].lowercased())_\(self.suits[playerSuit].lowercased())"
            let computerCardImage = "\(self.cardsNames[computerIndex].lowercased())_\(self.suits[computerSuit].lowercased())"
            
            self.plycard_img.image = UIImage(named: playerCardImage)
            self.compcard_img.image = UIImage(named: computerCardImage)
            
            if playerIndex > computerIndex {
                self.plyScore += 1
                self.name_lbl.text = "\(self.name) (\(self.plyScore))"
                self.roundres_lbl.text = "\(self.name) wins with a \(self.cardsNames[playerIndex]) of \(self.suits[playerSuit])!"
            } else {
                self.comScore += 1
                self.com_lbl.text = "House (\(self.comScore))"
                self.roundres_lbl.text = "House wins with a \(self.cardsNames[computerIndex]) of \(self.suits[computerSuit])!"
            }
            
            if self.currentRound < self.roundsNumber {
                self.currentRound += 1
                self.round_lbl.text = "Round: \(self.currentRound)"
            } else {
                self.isGameOver = true
                self.gameTimer?.invalidate()
                self.gameTimer = nil
                self.continue_btn.isEnabled = true
                self.round_lbl.text = "Game Over"
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ScoreViewController {
            destination.name = self.name
            destination.plyScore = self.plyScore
            destination.comScore = self.comScore
        }
    }
    
    // stop the timer when leaving the app
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    // continue the timer when returning to the app if game isn't over
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isGameOver {
            startTimer()
        }
    }
    
}
