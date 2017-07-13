//
//  ViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 05/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCrabPreferences(_ sender: Any) {
        user = User.Crab
        showGenreViewController()
    }
    
    @IBAction func selectFoxPreferences(_ sender: Any) {
        user = User.Fox
        showGenreViewController()
    }
    
    func showGenreViewController() {
        let genreVC = self.storyboard?.instantiateViewController(withIdentifier: "genreVC") as! GenreViewController
        genreVC.user = user
        self.present(genreVC, animated: true, completion: nil)
    }
}

