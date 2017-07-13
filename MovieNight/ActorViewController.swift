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
    var apiClient = MovieNightApiClient()
    var actors = [Actor]()
    var repository: Repository!
    var actorsSelected = [Int:String]()
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
        repository = Factory.createMovieNightRepository()
        
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
            loveButton.setImage(UIImage(named: "loveSelected"), for: .normal)
            loveButton.isSelected = true
             saveSelectedActor(with: indexPath)
        }
    }
    
    func saveSelectedActor(with indexPath: IndexPath) {
        let actorSelectedCell = actorTableView.cellForRow(at: indexPath) as! ActorTableViewCell
        actorsSelected[indexPath.row] = actorSelectedCell.nameLabel.text!
    }
    
    func removeSelectedActor(with indexPAth: IndexPath) {
        actorsSelected.removeValue(forKey: indexPAth.row)
    }
    
    // Called when the user taps 'Next' button
    @IBAction func saveActorsSelectedInDisk(_ sender: Any) {
        repository.save(dictionary: actorsSelected, forKey: "foxUserActors")
    }


}
