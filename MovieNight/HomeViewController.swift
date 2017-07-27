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
    @IBOutlet weak var resultButton: UIButton!
    let repository = Factory.createRepository()
    
    var crabGenres: [Int: Int]?
    var foxGenres:  [Int: Int]?
    
    override func viewDidLoad() {
        repository.cleanDisk()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        updateUi()
    }
    
    //Enable or Desable resultButton - Hide or show checkImageView
    func updateUi(){
        crabGenres = repository.retrieveDictionary(with: UserKeys.CrabUserGenres.rawValue)
        foxGenres = repository.retrieveDictionary(with: UserKeys.FoxUserGenres.rawValue)
        
        crabCheckedImageView.isHidden = crabGenres == nil
        foxCheckedImageView.isHidden = foxGenres == nil
        
        resultButton.isEnabled = crabGenres != nil && foxGenres != nil
        resultButton.alpha = resultButton.isEnabled ?  1.0 : 0.3
    }
    
    @IBAction func selectCrabPreferences(_ sender: Any) {
        showGenreViewController(with: User.Crab)
    }
    
    @IBAction func selectFoxPreferences(_ sender: Any) {
        showGenreViewController(with: User.Fox)
    }
    
    func showGenreViewController(with user: User) {
        if Reachability.isConnectedToNetwork() {
            let genreVC = self.storyboard?.instantiateViewController(withIdentifier: "genreVC") as! GenreViewController
            genreVC.user = user
            self.present(genreVC, animated: true, completion: nil)
        } else {
            showOfflineError(alertTitle: "You're offline", message: "Please connect to the internet and try again", actionTitle: "Ok")
        }
    }
    
    func showOfflineError(alertTitle: String, message: String, actionTitle: String) {
        let alert = Alert.create(alertTitle: alertTitle, message: message, actionTitle: "Ok")
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func clearUsersSelections(_ sender: Any) {
        // clean user's selections from disk
        repository.cleanDisk()
        updateUi()
    }
    
    // Segue that leads to view the result should just be executed if both users entered their preferences
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let shouldPerformSegue = crabGenres != nil && foxGenres != nil
        
        if !shouldPerformSegue{
            let alert = Alert.create(alertTitle: "Hey =)", message: "You should first enter your preferences before checking the result", actionTitle: "Ok")
            present(alert, animated: true, completion: nil)
        }
       
        return shouldPerformSegue
    }
    
    func unwindToHome(segue:UIStoryboardSegue) { }
}

