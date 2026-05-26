//
//  ViewController.swift
//  card-game
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var continue_btn: UIButton!
    @IBOutlet weak var name_insert_btn: UIButton!
    
    var name: String = ""
    
    @IBAction func name_insert_btn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Welcome", message: "Enter your name", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Save", style: .default) { _ in

            guard let inputName = alertController.textFields?.first?.text,
            !inputName.isEmpty else { return }
            
            self.name = inputName.capitalized
            self.name_lbl.text = "Hello \(self.name)"
            self.continue_btn.isEnabled = true

        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController {
            destination.name = self.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Force button label to be one line by decreasing font size as in some iPhones it's too long
        name_insert_btn.titleLabel?.numberOfLines = 1
        name_insert_btn.titleLabel?.adjustsFontSizeToFitWidth = true
        name_insert_btn.titleLabel?.minimumScaleFactor = 0.5
        
        if !name.isEmpty {
            name_lbl.text = "Hello \(name)"
            continue_btn.isEnabled = true
        }
    }

    // Returns the last screen to the home menu by clearing prev screens from the stack until we reach the first screen with unwindToStart
    // Used in order to avoid infinite stacks and being able to retain the name set previously
    @IBAction func unwindToStart(_ segue: UIStoryboardSegue) {
    }

}

