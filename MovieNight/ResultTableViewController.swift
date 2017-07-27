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
    let loadingView = UIView()
    let loadingLabel = UILabel()
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var topBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLoadingScreen()
        loadData()
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2) - (topBarView.frame.height)
        let origin = CGPoint(x: x, y: y)
        let size = CGSize(width: width, height: height)
        loadingView.frame = CGRect(origin: origin, size: size)
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Loading..."
        let originLabel = CGPoint(x: 0, y: 0)
        let sizeLabel = CGSize(width: 140, height: 30)
        self.loadingLabel.frame = CGRect(origin: originLabel, size:  sizeLabel)
        
        // Sets spinner
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        let activityIndicatorOrigin = CGPoint(x: 0, y: 0)
        let activityIndicatorSize = CGSize(width: 30, height: 30)
        self.activityIndicatorView.frame = CGRect(origin: activityIndicatorOrigin, size: activityIndicatorSize)
        self.activityIndicatorView.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.activityIndicatorView)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
        
    }
    
    func loadData() {
        let data = getDatafromDisk()
        
        matcher.matchUserSelections(with: data.foxGenres, and: data.crabGenres, and: data.foxActors, and: data.crabActors, and: data.crabMovies, and: data.foxMovies) { movies in
            self.removeLoadingScreen()
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
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        // Hides spinner
        self.activityIndicatorView.stopAnimating()
        self.loadingLabel.isHidden = true
        self.activityIndicatorView.isHidden = true
    }
    
}
