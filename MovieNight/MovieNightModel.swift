//
//  Movie.swift
//  MovieNight
//
//  Created by Tassia Serrao on 06/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

//Model


protocol JSONDecodable {
    init?(JSON: [String: AnyObject])
}

enum UserKeys: String {
    case FoxUserGenres
    case FoxUserActors
    case FoxUserMovies
    
    case CrabUserGenres
    case CrabUserActors
    case CrabUserMovies
}

enum User {
    case Fox
    case Crab
}

protocol Nameable {
    var name: String { get }
}

struct Actor: JSONDecodable, Equatable {
    var name: String
    var id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }

    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        guard let id = JSON["id"] as? Int else {
            return nil
        }
        self.name = name
        self.id = id
    }
    
    static func ==(lhs: Actor, rhs: Actor) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MovieCredits: JSONDecodable {
    var movieId: Int
    var actors = [String]()
    
    init?(JSON: [String: AnyObject]) {
        guard let cast = JSON["cast"] as? [[String : Any]] else {
            return nil
        }
        guard let id = JSON["id"] as? Int else {
            return nil
        }
        
        for actor in cast {
         self.actors.append(actor["name"] as! String)
        }
        
        self.movieId = id
    }
    
}

struct Movie : JSONDecodable {
    var title: String
    var releaseDate: String?
    var voteAverage: Int?
    var genreIds: [Int]
    var id: Int
    
    init(title: String, id: Int, genreIds: [Int]) {
        self.title = title
        self.id = id
        self.genreIds = genreIds
    }
    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["title"] as? String else {
            return nil
        }
        guard let id = JSON["id"] as? Int else {
            return nil
        }
        guard let genreIds = JSON["genre_ids"] as? [Int] else {
            return nil
        }
        self.title = name
        self.id = id
        self.genreIds = genreIds
    }
}

struct Genre: JSONDecodable, Equatable {
    var name: String
    var id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }

    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        guard let id = JSON["id"] as? Int else {
            return nil
        }
        self.name = name
        self.id = id
    }
    
    static func ==(lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
}



