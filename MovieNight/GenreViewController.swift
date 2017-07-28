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
    @IBOutlet weak var numberOfSelectedGenresLabel: UILabel!
    var genres = [Genre]()
    let apiClient = Factory.createApiClient()
    var repository = Factory.createRepository()
    var selectedGenres = [Int:Int]()
    var user = User.Fox
    var genresSelectedCount = 0
    let genresLimit = 2
    var selectedindexPaths = [Int]()
    var hasNextPage: Bool = true {
        didSet {
            self.page += 1
        }
    }
    var page = 1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        genreTableView.allowsSelection = false
        genreTableView.delegate = self
        genreTableView.dataSource = self

        loadData()
    }
    
    func loadData() {
        fetchGenres(with: page)
    }
    
    func fetchGenres(with page: Int) {
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
            fetchGenres(with: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreIdCell", for: indexPath) as! GenreTableViewCell
        cell.titleLabel.text = genres[indexPath.row].name
        
        // Assign the indexPath to the button's tag so the genre selected can be retreived when the button is tapped
        cell.loveButton.tag = indexPath.row
        
        if selectedindexPaths.contains(indexPath.row) {
            selectImageButton(button: cell.loveButton)
        } else {
            deselectImageButton(button: cell.loveButton)
        }

        return cell
    }
    
    func selectImageButton(button: UIButton) {
        button.setImage(UIImage(named: "loveSelected"), for: .normal)
        button.isSelected = true
    }
    
    func deselectImageButton(button: UIButton) {
        button.setImage(UIImage(named: "loveDeselected"), for: .normal)
        button.isSelected = false
    }
    
    func shouldFetchNextPage(indexPath: IndexPath) -> Bool {
        return (genres.count - indexPath.row) == 5 && hasNextPage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    @IBAction func didSelectGenre(_ sender: Any) {
        
        let loveButton = sender as! UIButton
        let indexPath = IndexPath(row: loveButton.tag, section: 0)
        
        if loveButton.isSelected {
            deselectImageButton(button: loveButton)
            removeSelectedGenre(with: indexPath)
        } else {
            
            //Show an alert in case the user have selected the limit amount of genres
            guard genresSelectedCount < genresLimit  else {
                let alert = Alert.create(alertTitle: "You've selected \(genresLimit) genres", message: "Please, go to next page", actionTitle: "Ok")
                present(alert, animated: true, completion: nil)
                return
            }
            
            selectImageButton(button: loveButton)
            saveSelectedGenre(with: indexPath)
        }
    }
    
    func saveSelectedGenre(with indexPath: IndexPath) {
        selectedindexPaths.append(indexPath.row)
        genresSelectedCount += 1
        updateNumberOfSelectedGenresLabel()
        selectedGenres[indexPath.row] = genres[indexPath.row].id
    }
    
    func removeSelectedGenre(with indexPAth: IndexPath) {
        selectedindexPaths = selectedindexPaths.filter { $0 != indexPAth.row }
        genresSelectedCount -= 1
        updateNumberOfSelectedGenresLabel()
        selectedGenres.removeValue(forKey: indexPAth.row)
    }
    
    func updateNumberOfSelectedGenresLabel() {
        numberOfSelectedGenresLabel.text = "\(genresSelectedCount) of \(genresLimit) selected"
    }
    
    // Called when the user taps 'Next' button
    @IBAction func saveGenresSelectedInDisk(_ sender: Any) {
        switch user {
            case .Fox :
                repository.save(dictionary: selectedGenres, for: UserKeys.FoxUserGenres.rawValue)
            case .Crab:
                repository.save(dictionary: selectedGenres, for: UserKeys.CrabUserGenres.rawValue)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let shouldPerformSegue = genresSelectedCount == genresLimit

        if !shouldPerformSegue{
            let alert = Alert.create(alertTitle: "Hey =)", message: "Please, select \(genresLimit) genres before going to next page", actionTitle: "Ok")
            present(alert, animated: true, completion: nil)
        }
        
        return shouldPerformSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let actorVC = segue.destination as! ActorViewController
        actorVC.user = user
    }
}








