//
//  GameViewController.swift
//  card-game
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var name_lbl: UILabel!
    var name: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name_lbl.text = name
    }
    
    
    

}
