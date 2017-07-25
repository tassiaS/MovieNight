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
    var movies = [Movie]()
    var selectedMovies = [Int: Int]()
    let apiClient = Factory.createApiClient()
    var repository = Factory.createRepository()
    var page = 1
    var user = User.Fox
    var hasNextPage: Bool = true {
        didSet {
            self.page += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        loadData()
    }
    
    func loadData() {
        fetchMovies(with: page)
    }
    
    func fetchMovies(with page: Int) {
        let endpoint = MovieNightEndpoint.Movie(page: String(page))
        
        apiClient.fetchMovies(endpoint: endpoint) { [weak self] (results) in
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
        
        if shouldFetchNextPage(indexPath: indexPath) {
            fetchMovies(with: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieIdCell", for: indexPath) as! MovieTableViewCell
        cell.titleLabel.text = movies[indexPath.row].title
        cell.id = movies[indexPath.row].id
        // Assign the indexPath to the button's tag so the movie selected can be retreived when the button is tapped
        cell.loveButton.tag = indexPath.row

        return cell
    }
    
    func shouldFetchNextPage(indexPath: IndexPath) -> Bool {
        return (movies.count - indexPath.row) == 5 && hasNextPage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    @IBAction func didSelectMovie(_ sender: Any) {
        let loveButton = sender as! UIButton
        let indexPath = IndexPath(row: loveButton.tag, section: 0)
        
        if loveButton.isSelected {
            loveButton.setImage(UIImage(named: "loveDeselected"), for: .normal)
            loveButton.isSelected = false
            removeSelectedMovie(with: indexPath)
        } else {
            loveButton.setImage(UIImage(named: "loveSelected"), for: .normal)
            loveButton.isSelected = true
            saveSelectedMovie(with: indexPath)
        }
    }
    
    func saveSelectedMovie(with indexPath: IndexPath) {
        //let movieSelectedCell = movieTableView.cellForRow(at: indexPath) as! MovieTableViewCell
        //selectedMovies[movieSelectedCell.id] = movieSelectedCell.titleLabel.text!
        selectedMovies[indexPath.row] = movies[indexPath.row].id
    }
    
    func removeSelectedMovie(with indexPAth: IndexPath) {
        selectedMovies.removeValue(forKey: indexPAth.row)
    }
    
    // Called when the user taps the 'Done' button
    @IBAction func saveMoviesSelectedInDisk(_ sender: Any) {
        switch user {
        case .Fox :
            repository.save(dictionary: selectedMovies, for: UserKeys.FoxUserMovies.rawValue)
        case .Crab:
            repository.save(dictionary: selectedMovies, for: UserKeys.CrabUserMovies.rawValue)
        }
        showHomeViewControlle()
    }
    
    func showHomeViewControlle() {
        let homeVC = storyboard?.instantiateInitialViewController() as! HomeViewController
        self.present(homeVC, animated: true, completion: nil)
    }
}












