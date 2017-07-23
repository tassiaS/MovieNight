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

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    func loadData() {
        
        var foxMovies = [Movie]()
        foxMovies.append(Movie(title: "Despicable Me 3", id: 324852, genreIds: [878,12,16,35,10751]))
        foxMovies.append(Movie(title: "Beauty and the Beast", id: 321612, genreIds: [10751,14,10749]))
        
        var crabMovies = [Movie]()
        crabMovies.append(Movie(title: "Dawn of the Planet of the Apes", id: 119450, genreIds: [878,28,18,53]))
        crabMovies.append(Movie(title: "Spider-Man: Homecoming", id: 315635, genreIds: [28,12,878]))
        
        //test
        
        let genre1 = Genre(name: "Action", id: 28)
        let genre2 = Genre(name: "Science Fiction", id: 878)
        var foxGenres = [Genre]()
        foxGenres.append(genre1)
        foxGenres.append(genre2)
        
        var crabGenres = [Genre]()
        let genre3 = Genre(name: "Horror", id: 27)
        let genre4 = Genre(name: "Drama", id: 18)
        crabGenres.append(genre3)
        crabGenres.append(genre4)
        
        let actor1 = Actor(name: "Andy Serkis", id:  28)
        let actor2 = Actor(name: "Henry Cavill", id: 1099)
        var foxActors = [Actor]()
        foxActors.append(actor1)
        foxActors.append(actor2)
        let actor3 = Actor(name: "Emilia Clarke", id:  1099)
        let actor4 = Actor(name: "Lena Headey", id: 10990)
        var crabActors = [Actor]()
        crabActors.append(actor3)
        crabActors.append(actor4)
        
        
        matcher.matchUserSelections(with: foxGenres, and: crabGenres, and: foxActors, and: crabActors, and: crabMovies, and: foxMovies) { movies in
            self.recommendedMovies = movies
            self.tableView.reloadData()
        }
        
        guard let data = UserDefaults.standard.object(forKey: "user1") else {
            return print("no data")
        }
        
        // Check if retrieved data has correct type
        guard data is Data else {
            return print("no correct type")
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultIdCell", for: indexPath) as! ResultTableViewCell
        cell.titleLabel.text = recommendedMovies[indexPath.row].title
        return cell
        
    }
    
}
