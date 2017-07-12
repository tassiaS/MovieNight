//
//  MovieViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 11/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var movieTableView: UITableView!
    var apiClient = MovieNightApiClient()
    var movies = [Movie]()
    var hasNextPage: Bool = true {
        didSet {
            self.page += 1
        }
    }
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        loadData()
    }
    
    func loadData() {
        fetchForMovies(with: page)
    }
    
    func fetchForMovies(with page: Int) {
        apiClient.fetchMovies(page: page) { [weak self] (results) in
            switch results {
                case .failure(let error) :
                    print(error)
                case .success(let resource, let hasPage) :
                    self?.movies += resource
                    self?.hasNextPage = hasPage
                    self?.movieTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (movies.count - indexPath.row) == 3 && hasNextPage {
            fetchForMovies(with: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieIdCell", for: indexPath) as! MovieTableViewCell
        cell.titleLabel.text = movies[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
}
