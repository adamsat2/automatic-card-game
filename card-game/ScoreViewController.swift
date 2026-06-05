//
//  ScoreViewController.swift
//  card-game
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var result_lbl: UILabel!
    
    var name: String = ""
    var score: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setResultLabel()
        
        if name == "The House" {
            SoundManager.shared.playSound(soundName: "lose")
        } else {
            SoundManager.shared.playSound(soundName: "win")
        }
    }
    
    func setResultLabel() {
        
        result_lbl.text = "The winner is \(name)!\n with the score: \(score)"

    }

}
