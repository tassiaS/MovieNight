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
        fetchForActors(with: page)
    }
    
    func fetchForActors(with page: Int) {
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
            fetchForActors(with: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorIdCell", for: indexPath) as! ActorTableViewCell
        cell.nameLabel.text = actors[indexPath.row].name
        return cell
    }
    
    func shouldFetchNextPage(indexPath: IndexPath) -> Bool {
        return (actors.count - indexPath.row) == 5 && hasNextPage ? true : false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
}
