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
    var moviesSelected = [Int: String]()
    var repository: Repository!
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
        repository = Factory.createMovieNightRepository()
        
        loadData()
    }
    
    func loadData() {
        fetchMovies(with: page)
    }
    
    func fetchMovies(with page: Int) {
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
        let movieSelectedCell = movieTableView.cellForRow(at: indexPath) as! MovieTableViewCell
        moviesSelected[movieSelectedCell.id] = movieSelectedCell.titleLabel.text!
    }
    
    func removeSelectedMovie(with indexPAth: IndexPath) {
        moviesSelected.removeValue(forKey: indexPAth.row)
    }
    
    // Called when the user taps the 'Done' button
    @IBAction func saveMoviesSelectedInDisk(_ sender: Any) {
        switch user {
        case .Fox :
            repository.save(dictionary: moviesSelected, forKey: UserKeys.FoxUserMovies.rawValue)
        case .Crab:
            repository.save(dictionary: moviesSelected, forKey: UserKeys.CrabUserMovies.rawValue)
        }
    
//        let savedDictionary1 = repository.retrieveDictionary(withKey: UserKeys.CrabUserGenres.rawValue) // Retrieve
//        repository.userDefault.synchronize()
//        print("saveDict\(String(describing: savedDictionary1))")
    }
}












