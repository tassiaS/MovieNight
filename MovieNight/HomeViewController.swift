//
//  ViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 05/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
   
    @IBOutlet weak var foxCheckedImageView: UIImageView!
    @IBOutlet weak var crabCheckedImageView: UIImageView!
    let repository = Factory.createRepository()
  
    override func viewWillAppear(_ animated: Bool) {
        let crabGenres = repository.retrieveDictionary(with: UserKeys.CrabUserGenres.rawValue)
        let foxGenres = repository.retrieveDictionary(with: UserKeys.FoxUserActors.rawValue)
        
        crabCheckedImageView.isHidden = crabGenres == nil
        foxCheckedImageView.isHidden = foxGenres == nil
    }
    
    @IBAction func selectCrabPreferences(_ sender: Any) {
        checkInternetConnection()
    }
    
    @IBAction func selectFoxPreferences(_ sender: Any) {
        checkInternetConnection()
    }
    
    func showGenreViewController(with user: User) {
        let genreVC = self.storyboard?.instantiateViewController(withIdentifier: "genreVC") as! GenreViewController
        genreVC.user = user
        self.present(genreVC, animated: true, completion: nil)
    }
    
    func showOfflineError() {
        let alert = UIAlertController(title: "You're offline", message: "Please connect to the internet and try again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInternetConnection() {
        Reachability.isConnectedToNetwork() ? showGenreViewController(with: User.Fox) : showOfflineError()
    }
    
    @IBAction func clearUsersSelections(_ sender: Any) {
        // clean user's selections from disk
        repository.cleanDisk()
        crabCheckedImageView.isHidden = true
        foxCheckedImageView.isHidden = true
    }
    
    func unwindToHome(segue:UIStoryboardSegue) { }
}

