//
//  WelcomeViewController.swift
//  DailyExpense
//
//  Created by UCF on 19/08/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var aniamatedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func LetStartButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
       // self.tabBarController?.selectedIndex = 3
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
}




