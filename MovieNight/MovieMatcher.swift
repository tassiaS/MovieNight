//
//  MovieMatcher.swift
//  MovieNight
//
//  Created by Tassia Serrao on 15/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

protocol Matcher {
    func matchUserSelections(with foxGenres: [Genre], and crabGenres: [Genre], and foxActors: [Actor], and crabActors: [Actor], and crabMovies: [Movie], and foxMovies: [Movie], completionHandler: @escaping ([Movie]) -> Void)
}

class MovieNightMatcher: Matcher {
    
    var apiCLient = Factory.createApiClient()
    var recommendedMovies = [[Movie]]()
    var moviesMatchedByGenre: [Movie] = [Movie]()
    var moviesMatchedByActor: [Movie] = [Movie]()
    var allRecommendedMovies = [Movie]()
    var moviesCredits = [[Credit]]()
    var matchedMoviesByGenreAndActor: [Movie] = [Movie]()

    func matchUserSelections(with foxGenres: [Genre], and crabGenres: [Genre], and foxActors: [Actor], and crabActors: [Actor], and crabMovies: [Movie], and foxMovies: [Movie], completionHandler: @escaping ([Movie]) -> Void) {
        
        let moviesSelected = foxMovies + crabMovies
        
        // First: get movies recommendations from user's movies selections
        getMovieRecommendations(from: moviesSelected, completionHandler: { movies in
            
            //convert to [Movies] instead of [[Movie]]
            self.allRecommendedMovies = Array(movies.joined())
            
            // Second: check if the users have a genre or actor in common
            let equalGenres:[Genre]? = self.checkForEqualElements(of: foxGenres, and: crabGenres)
            let equalActors: [Actor]? = self.checkForEqualElements(of: foxActors, and: crabActors)
            
            // Third: If the users have a genre in common, then check for recommendedMovies with those genres
            if let genres = equalGenres {
                for genre in genres {
                    self.moviesMatchedByGenre = self.allRecommendedMovies.filter { $0.genreIds.contains(genre.id) }
                }
            }
            
            // Fourth: If the users have some actor in common, then check for recommendedMovies with those actors
            if let actors = equalActors {
                // Get the credits of all recommendedMovies so it is possible to check if one of them have 'the equal actor' in its cast
                self.getCredits(of: self.allRecommendedMovies, completionHandler: { moviesCredits in
                    for credits in moviesCredits {
                        let movieCreditsMatchedByActor = credits.filter { actors.contains($0.actor) }
                        
                        // Ger from allRecommendedMovies only the movies with 'actors matched'
                        for credit in movieCreditsMatchedByActor {
                            let moviesMatched = self.allRecommendedMovies.filter { $0.id == credit.movieId }
                            for movie in moviesMatched {
                                self.moviesMatchedByActor.append(movie)
                            }
                        }
                    }
                    
                    if !(self.moviesMatchedByGenre.isEmpty) {
                        for movie in self.moviesMatchedByGenre {
                            self.matchedMoviesByGenreAndActor.append(movie)
                        }
                    }
                    
                    if !(self.moviesMatchedByActor.isEmpty) {
                        for movie in self.moviesMatchedByActor {
                            self.matchedMoviesByGenreAndActor.append(movie)
                        }
                    }
                    
                    // Can be called to show the results only after all the credits were checked
                    DispatchQueue.main.async {
                        if !(self.matchedMoviesByGenreAndActor.isEmpty) {
                            completionHandler(self.matchedMoviesByGenreAndActor.uniq())
                            print(self.matchedMoviesByGenreAndActor.count)
                            
                        } else {
                            completionHandler(self.allRecommendedMovies.uniq())
                            print(self.allRecommendedMovies.count)
                        }
                    }
                })
            }
        })
    }
    
    private func getMovieRecommendations(from movies: [Movie], completionHandler: @escaping (_ allRecommendedMovies: [[Movie]])-> Void) {
        let group = DispatchGroup()
        let moviesId = movies.map { String($0.id) }
        let endpoints = moviesId.map { MovieNightEndpoint.MovieRecommendations(id: $0) }
        
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
            completionHandler(self.recommendedMovies)
        }
    }
    
    private func checkForEqualElements<T: Equatable>(of fox: [T], and crab: [T]) -> [T]? {
        
        let equalFox = fox.filter { crab.contains($0) }
        return equalFox
    }

    private func getCredits(of movies: [Movie], completionHandler: @escaping (_ moviesCredits: [[Credit]]) -> Void) {
        let group = DispatchGroup()
        let moviesId = movies.map { String($0.id) }
        let endpoints = moviesId.map { MovieNightEndpoint.MovieCredits(id: $0) }
        
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
            completionHandler(self.moviesCredits)
        }
    }
}

// Remove duplications
extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}
