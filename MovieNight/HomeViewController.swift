//
//  ViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 05/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
   
    @IBAction func selectCrabPreferences(_ sender: Any) {
        showGenreViewController(with: User.Crab)
    }
    
    @IBAction func selectFoxPreferences(_ sender: Any) {
        showGenreViewController(with: User.Fox)
    }
    
    func showGenreViewController(with user: User) {
        let genreVC = self.storyboard?.instantiateViewController(withIdentifier: "genreVC") as! GenreViewController
        genreVC.user = user
        self.present(genreVC, animated: true, completion: nil)
    }
}

