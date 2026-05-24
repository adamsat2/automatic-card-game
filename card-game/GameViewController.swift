//
//  GameViewController.swift
//  card-game
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var round_lbl: UILabel!
    @IBOutlet weak var com_lbl: UILabel!
    @IBOutlet weak var continue_btn: UIButton!
    
    var name: String = ""
    var currentRound: Int = 1
    var gameTimer : Timer?
    var plyScore: Int = 0
    var comScore: Int = 0
    var isGameOver: Bool = false
    
    let roundsNumber: Int = 5
    let cardsNames: [String] = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name_lbl.text = "\(name) (\(plyScore))"
        com_lbl.text = "House (\(comScore))"
        round_lbl.text = "Round: \(currentRound)"
    }
    
    func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in  guard let self = self else { return }
            let playerIndex = Int.random(in: 0..<self.cardsNames.count)
            let computerIndex = Int.random(in: 0..<self.cardsNames.count)
            
            if playerIndex > computerIndex {
                self.plyScore += 1
                self.name_lbl.text = "\(self.name) (\(self.plyScore))"
            } else {
                self.comScore += 1
                self.com_lbl.text = "House (\(self.comScore))"
            }
            
            if self.currentRound < self.roundsNumber {
                self.currentRound += 1
                self.round_lbl.text = "Round: \(self.currentRound)"
            } else {
                self.isGameOver = true
                self.gameTimer?.invalidate()
                self.gameTimer = nil
                self.continue_btn.isEnabled = true
                print("Game Over")
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
