//
//  GenreViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 09/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var genreTableView: UITableView!
    var genres = [Genre]()
    let apiClient = MovieNightApiClient()


    override func viewDidLoad() {
        super.viewDidLoad()
        genreTableView.delegate = self
        genreTableView.dataSource = self

        loadData()
    }
    
    func loadData() {
        fetchForGenres()
    }
    
    func fetchForGenres() {
        apiClient.fetchForGenre { [weak self] (result) in
            switch result {
            case .failure(let error) : print(error)
            case .success(let resource, _) :
                self?.genres = resource
                self?.genreTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreIdCell", for: indexPath) as! GenreTableViewCell
        cell.titleLabel.text = genres[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
}
