//
//  ScoreViewController.swift
//  card-game
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var result_lbl: UILabel!
    
    var name: String = ""
    var plyScore: Int = 0
    var comScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setResultLabel()
    }
    
    func setResultLabel() {
        let plyScore = self.plyScore
        let comScore = self.comScore
        
        if plyScore > comScore {
            result_lbl.text = "Congratulations \(name)! You won with the final score being \(plyScore):\(comScore)"
        } else {
            result_lbl.text = "The house won with the final score being \(plyScore):\(comScore)"
        }

    }

}
