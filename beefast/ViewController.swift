//
//  ViewController.swift
//  tests
//
//  Created by Simon on 18/07/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    var lastRestart: Int?
    var lost: Bool = false

    func randomTimeout() -> DispatchTime {
        return DispatchTime.now() + DispatchTimeInterval.milliseconds(Int.random(in: 1000...4000))
    }
    
    func makeButtonClickable() {
        let bee:UIImage? = UIImage(named: "bee.png")
        submitButton.setTitle(nil, for: .normal)
        submitButton.setBackgroundImage(bee, for: .normal)
        submitButton.backgroundColor = UIColor.red
        lastRestart = Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func triggerButtonClickableTimeout() {
        submitButton.setTitle("Pas d'abeille en vue...", for: .normal)
        submitButton.backgroundColor = UIColor.cyan
        DispatchQueue.main.asyncAfter(deadline: randomTimeout()) {
            if !self.lost {
                self.makeButtonClickable()
            }
        }
    }
    
    func showSuccessButton() {
        submitButton.titleLabel?.textAlignment = .center
        submitButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let time = Int(Int(NSDate().timeIntervalSince1970 * 1000) - lastRestart!)
        submitButton.setBackgroundImage(nil, for: .normal)
        submitButton.setTitle("Bravo ! Vous avez cliqué en \(time) ms ! Cliquez pour réessayer.", for: .normal)
        submitButton.backgroundColor = UIColor.green
    }
    
    func showLooseButton() {
        submitButton.titleLabel?.textAlignment = .center
        submitButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        submitButton.setTitle("Perdu ! Vous avez cliqué alors qu'il n'y avait pas d'abeille... Cliquez pour réessayer.", for: .normal)
        submitButton.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        self.triggerButtonClickableTimeout()
    }
    
    @IBAction func submitButtonPressed() {

        let state = submitButton.currentTitle
        
        if state == nil {
            showSuccessButton()
        } else if state!.starts(with: "Bravo !") {
            lost = false
            triggerButtonClickableTimeout()
        } else if state!.starts(with: "Perdu !") {
            lost = false
            triggerButtonClickableTimeout()
        } else if state == "Pas d'abeille en vue..." {
            lost = true
            showLooseButton()
            // do nothing
            return
        }

    }
}

