//
//  MovieMatcher.swift
//  MovieNight
//
//  Created by Tassia Serrao on 15/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

protocol Matcher {
    func matchUserSelections(with genres: [[Genre]]?, actors: [[Actor]]?, movies: [[Movie]], completionHandler: @escaping (_ movies: [Movie]) -> Void)
}

class MovieNightMatcher: Matcher {
    
    var apiCLient = Factory.createApiClient()
    var recommendedMovies = [[Movie]]()
    var moviesId = [String]()
    var moviesMatchedByGenre: [Movie]?
    var moviesMatchedByActor: [Movie]?
    var allRecommendedMovies = [Movie]()
    var moviesCredits = [[MovieCredits]]()
    var matchedMovies: [Movie]?

    // Gonna have two arrays of each selection to represent a different user
    func matchUserSelections(with genres: [[Genre]]?, actors: [[Actor]]?, movies: [[Movie]], completionHandler: @escaping ([Movie]) -> Void) {
        
        let foxGenre = genres?[0]
        let crabGenre = genres?[1]
        
        let foxActor = actors?[0]
        let crabActor = actors?[1]
        
        var moviesSelected = [Movie]()
        // get two aleatory selections from each user
        for UserMovies in movies {
            for i in 0...1 {
                moviesSelected.append(UserMovies[i])
            }
        }
        // First: get movies recommendations from user's movies selections
        getMovieRecommendations(from: moviesSelected, completionHandler: {
            
            self.allRecommendedMovies = Array(self.recommendedMovies.joined())
            
            
            // Second: check if the users have a genre or actor in common
            let equalGenres:[Genre]? = self.checkForEqualElements(of: foxGenre!, and: crabGenre!)
            let equalActors: [Actor]? = self.checkForEqualElements(of: foxActor!, and: crabActor!)
            
            // Third: If the users have a genre in common, then check for recommendedMovies with those genres
            if let genres = equalGenres {
                for genre in genres {
                    self.moviesMatchedByGenre = self.allRecommendedMovies.filter { $0.genreIds.contains(genre.id) }
                }
            }
            
            // Fourth: If the users have some actor in common, then check for recommendedMovies with those actors
            if let actors = equalActors {
                self.getCredits(of: self.allRecommendedMovies, completionHandler: {
                    let allMoviesCredits = Array(self.moviesCredits.joined())
                    
                    for actor in actors {
                        let movieCreditsMatchedByActor = allMoviesCredits.filter { $0.actors.contains(actor.name) }
                        
                        for movieCredits in movieCreditsMatchedByActor {
                            self.moviesMatchedByActor = self.allRecommendedMovies.filter { $0.id == movieCredits.movieId}
                        }
                    }
                })
            }
            
            if let moviesMacthedByGenre = self.moviesMatchedByGenre {
                self.matchedMovies = moviesMacthedByGenre
            }
            
            if let moviesMatchedByActor = self.moviesMatchedByActor {
                self.matchedMovies = moviesMatchedByActor
            }
            
            DispatchQueue.main.async {
                if let matchedMovies = self.matchedMovies {
                    completionHandler(matchedMovies)
                    
                } else {
                    completionHandler(self.allRecommendedMovies)
                }
            }
        })

    }

    func getCredits(of movies: [Movie], completionHandler: @escaping () -> Void) {
        let group = DispatchGroup()
        
        for movie in allRecommendedMovies {
            moviesId.append(String(movie.id))
        }
        
        var endpoints = [MovieNightEndpoint]()
        for id in moviesId {
            let endpoint = MovieNightEndpoint.MovieCredits(id: id)
            endpoints.append(endpoint)
        }
        
        
        for endpoint in endpoints {
            group.enter()
            apiCLient.fetchMovieCredits(endpoint: endpoint, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let resource , _):
                    self.moviesCredits.append(resource)
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            print("All async calls were run!")
            completionHandler()
        }
    }

    func checkForEqualElements<T: Equatable>(of fox: [T], and crab: [T]) -> [T]? {
        
        let equalFox = fox.filter { crab.contains($0) }
        return equalFox
    }
    

    func getMovieRecommendations(from movies: [Movie], completionHandler: @escaping ()-> Void) {
        
        let group = DispatchGroup()
        
        for movie in movies {
            moviesId.append(String(movie.id))
        }
        
        var endpoints = [MovieNightEndpoint]()
        for id in moviesId {
            let endpoint = MovieNightEndpoint.MovieRecommendations(id: id)
            endpoints.append(endpoint)
        }
        
        
        for endpoint in endpoints {
            group.enter()
            apiCLient.fetchMovies(endpoint: endpoint, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let resource , _):
                    self.recommendedMovies.append(resource)
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            print("All async calls were run!")
            completionHandler()
        }
    }
}


