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
    var hasNextPage: Bool = true {
        didSet {
            self.page += 1
        }
    }
    var page = 1


    override func viewDidLoad() {
        super.viewDidLoad()
        genreTableView.delegate = self
        genreTableView.dataSource = self

        loadData()
    }
    
    func loadData() {
        fetchForGenres(with: page)
    }
    
    func fetchForGenres(with page: Int) {
        apiClient.fetchGenres(page: page) { [weak self] (result) in
            switch result {
            case .failure(let error) : print(error)
            case .success(let resource, let hasPage) :
                self?.genres = resource
                self?.hasNextPage = hasPage
                self?.genreTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if shouldFetchNextPage(indexPath: indexPath) {
            fetchForGenres(with: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreIdCell", for: indexPath) as! GenreTableViewCell
        cell.titleLabel.text = genres[indexPath.row].name
        return cell
    }
    
    func shouldFetchNextPage(indexPath: IndexPath) -> Bool {
        return (genres.count - indexPath.row) == 5 && hasNextPage ? true : false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
}
