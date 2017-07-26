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
    var crabGenres: [Int: Int]?
    var foxGenres:  [Int: Int]?
  
    override func viewWillAppear(_ animated: Bool) {
        crabGenres = repository.retrieveDictionary(with: UserKeys.CrabUserGenres.rawValue)
        foxGenres = repository.retrieveDictionary(with: UserKeys.FoxUserGenres.rawValue)
        
        crabCheckedImageView.isHidden = crabGenres == nil
        foxCheckedImageView.isHidden = foxGenres == nil
    }
    
    @IBAction func selectCrabPreferences(_ sender: Any) {
        checkInternetConnection(user: User.Crab)
    }
    
    @IBAction func selectFoxPreferences(_ sender: Any) {
        checkInternetConnection(user: User.Fox)
    }
    
    func showGenreViewController(with user: User) {
        let genreVC = self.storyboard?.instantiateViewController(withIdentifier: "genreVC") as! GenreViewController
        genreVC.user = user
        self.present(genreVC, animated: true, completion: nil)
    }
    
    func showOfflineError(alertTitle: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInternetConnection(user: User) {
        if Reachability.isConnectedToNetwork() {
            showGenreViewController(with: user)
        } else {
         showOfflineError(alertTitle: "You're offline", message: "Please connect to the internet and try again", actionTitle: "Ok")
        }
    }
    
    @IBAction func clearUsersSelections(_ sender: Any) {
        // clean user's selections from disk
        repository.cleanDisk()
        crabCheckedImageView.isHidden = true
        foxCheckedImageView.isHidden = true
    }
    
    // Segue that leads to view the result should just be executed if both users entered their preferences
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let shouldPerformSegue = crabGenres != nil && foxGenres != nil
        
        if !shouldPerformSegue{
            showOfflineError(alertTitle: "Hey =)", message: "You should first enter your preferences before checking the result", actionTitle: "Ok")
        }
       
        return shouldPerformSegue
    }
    
    func unwindToHome(segue:UIStoryboardSegue) { }
}

