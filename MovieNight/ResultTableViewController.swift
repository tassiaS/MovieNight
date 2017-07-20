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
        
        var user1movies = [Movie]()
        user1movies.append(Movie(title: "Despicable Me 3", id: 324852, genreIds: [878,12,16,35,10751]))
        user1movies.append(Movie(title: "Beauty and the Beast", id: 321612, genreIds: [10751,14,10749]))
        
        var user2movies = [Movie]()
        user2movies.append(Movie(title: "Dawn of the Planet of the Apes", id: 119450, genreIds: [878,28,18,53]))
        user2movies.append(Movie(title: "Spider-Man: Homecoming", id: 315635, genreIds: [28,12,878]))
        
        var movies = [[Movie]]()
        movies.append(user1movies)
        movies.append(user2movies)
        
        //test
        
        var genres = [[Genre]]()
        
        let genre1 = Genre(name: "Action", id: 28)
        let genre2 = Genre(name: "Science Fiction", id: 878)
        var fox = [Genre]()
        fox.append(genre1)
        fox.append(genre2)
        
        var crab = [Genre]()
        let genre3 = Genre(name: "Horror", id: 27)
        let genre4 = Genre(name: "Drama", id: 18)
        crab.append(genre3)
        crab.append(genre4)
        
        genres.append(fox)
        genres.append(crab)
        
        var actors = [[Actor]]()
        
        let actor1 = Actor(name: "Andy Serkis", id: 1333)
        let actor2 = Actor(name: "Henry Cavill", id: 73968)
        var actorF = [Actor]()
        actorF.append(actor1)
        actorF.append(actor2)
        var actor3 = Actor(name: "Emilia Clarke", id: 1223786)
        var actor4 = Actor(name: "Lena Headey", id: 17286)
        var actorC = [Actor]()
        actorC.append(actor3)
        actorC.append(actor4)
        
        actors.append(actorF)
        actors.append(actorC)
        
        
        
        matcher.matchUserSelections(with : genres, actors: actors, movies: movies, completionHandler: { movies in
            self.recommendedMovies = movies
            self.tableView.reloadData()
            print("The result is \(movies)")
        })
        
        
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
