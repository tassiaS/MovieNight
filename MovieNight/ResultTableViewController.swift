//
//  ResultTableViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 10/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    var matcher = MovieNightMatcher()
    var recommendedMovies = [Movie]()
    var repository = Factory.createRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        let data = getDatafromDisk()
        
        matcher.matchUserSelections(with: data.foxGenres, and: data.crabGenres, and: data.foxActors, and: data.crabActors, and: data.crabMovies, and: data.foxMovies) { movies in
            self.recommendedMovies = movies
            self.tableView.reloadData()
        }
    }
    
    func getDatafromDisk() -> (crabGenres: [Genre], foxGenres: [Genre], crabActors: [Actor], foxActors: [Actor], crabMovies: [Movie], foxMovies: [Movie]) {
        
        let crabGenres = getGenres(key: UserKeys.CrabUserGenres.rawValue)
        let foxGenres = getGenres(key: UserKeys.FoxUserActors.rawValue)
        let crabActors = getActors(key: UserKeys.CrabUserActors.rawValue)
        let foxActors = getActors(key: UserKeys.FoxUserActors.rawValue)
        let crabMovies = getMovies(key: UserKeys.CrabUserMovies.rawValue)
        let foxMovies = getMovies(key: UserKeys.FoxUserMovies.rawValue)

        return (crabGenres, foxGenres, crabActors, foxActors, crabMovies, foxMovies)
    }
    
    func getGenres(key: String) -> [Genre] {
        let genres = getData(with: key) { (value) -> Genre in
            return Genre(name: "", id: value)
        }
        return genres
    }
    
    func getActors(key: String) -> [Actor] {
        let actors = getData(with: key) { (value) -> Actor in
            return Actor(name: "", id: value)
        }
        return actors
    }
    
    func getMovies(key: String) -> [Movie] {
        let movies = getData(with: key) { (value) -> Movie in
            return Movie(title: "", id: value, genreIds: nil)
        }
        return movies
    }
    
    func getData<T>(with key: String, createObject: (_ value: Int) -> T) -> [T] {
        var array = [T]()
        let dict = repository.retrieveDictionary(with: key)
        if let dict = dict {
            for (_, value) in dict {
                let object = createObject(value)
                array.append(object)
            }
        }
        repository.userDefault.synchronize()
        return array
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultIdCell", for: indexPath) as! ResultTableViewCell
        cell.titleLabel.text = recommendedMovies[indexPath.row].title
        return cell
    }
    
    @IBAction func didClickDone(_ sender: Any) {
        // clean user's selections from disk
        repository.cleanDisk()
        dismiss(animated: true, completion: nil)
    }
    
}
