//
//  ActorViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 09/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class ActorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var actorTableView: UITableView!
    var actors = [Actor]()
    let apiClient = Factory.createApiClient()
    var repository = Factory.createRepository()
    var selectedActors = [Int:Int]()
    var user = User.Fox
    var actorsSelectedCount = 0
    let actorsLimit = 3
    @IBOutlet weak var numberOfSelectedActorsLabel: UILabel!
    var hasNextPage: Bool = true {
        didSet {
            self.page += 1
        }
    }
    var page = 1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actorTableView.delegate = self
        actorTableView.dataSource = self
        
        loadData()
    }
    
    func loadData() {
        fetchActors(with: page)
    }
    
    func fetchActors(with page: Int) {
        apiClient.fetchActors(page: page) { [weak self] (result) in
            switch result {
            case .failure(let error) :
                return print(error)
            case .success(let resource, let hasPage):
                self?.actors += resource
                self?.hasNextPage = hasPage
                self?.actorTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if shouldFetchNextPage(indexPath: indexPath) {
            fetchActors(with: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorIdCell", for: indexPath) as! ActorTableViewCell
        cell.nameLabel.text = actors[indexPath.row].name
        // Assign the indexPath to the button's tag so the actor selected can be retreived when the button is tapped
        cell.loveButton.tag = indexPath.row
        
        return cell
    }
    
    func shouldFetchNextPage(indexPath: IndexPath) -> Bool {
        return (actors.count - indexPath.row) == 5 && hasNextPage ? true : false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    @IBAction func didSelectActor(_ sender: Any) {
        
        let loveButton = sender as! UIButton
        let indexPath = IndexPath(row: loveButton.tag, section: 0)
        
        if loveButton.isSelected {
            loveButton.setImage(UIImage(named: "loveDeselected"), for: .normal)
            loveButton.isSelected = false
            removeSelectedActor(with: indexPath)
        } else {
            
            //Show an alert in case the user have selected the limit amount of actors
            guard actorsSelectedCount < actorsLimit  else {
                let alert = Alert.create(alertTitle: "You've selected 3 actors", message: "Please, go to next page", actionTitle: "Ok")
                present(alert, animated: true, completion: nil)
                return
            }

            loveButton.setImage(UIImage(named: "loveSelected"), for: .normal)
            loveButton.isSelected = true
             saveSelectedActor(with: indexPath)
        }
    }
    
    func saveSelectedActor(with indexPath: IndexPath) {
        actorsSelectedCount += 1
        updateNumberOfSelectedActorsLabel()
        selectedActors[indexPath.row] = actors[indexPath.row].id
    }
    
    func removeSelectedActor(with indexPAth: IndexPath) {
        actorsSelectedCount -= 1
        updateNumberOfSelectedActorsLabel()
        selectedActors.removeValue(forKey: indexPAth.row)
    }
    
    func updateNumberOfSelectedActorsLabel() {
        numberOfSelectedActorsLabel.text = "\(actorsSelectedCount) of 3 selected"
    }
    
    // Called when the user taps 'Next' button
    @IBAction func saveActorsSelectedInDisk(_ sender: Any) {
        switch user {
        case .Fox :
            repository.save(dictionary: selectedActors, for: UserKeys.FoxUserActors.rawValue)
        case .Crab:
            repository.save(dictionary: selectedActors, for: UserKeys.CrabUserActors.rawValue)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let shouldPerformSegue = actorsSelectedCount == actorsLimit
        
        if !shouldPerformSegue{
            let alert = Alert.create(alertTitle: "Hey =)", message: "Please, select 3 actors before going to next page", actionTitle: "Ok")
            present(alert, animated: true, completion: nil)
        }
        
        return shouldPerformSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieVC = segue.destination as! MovieViewController
        movieVC.user = user
    }
}
