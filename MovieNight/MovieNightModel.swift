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

struct Credit {
    var movieId: Int
    var actor: Actor
    
    init?(JSON: [String: AnyObject], movieId: Int) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        guard let id = JSON["id"] as? Int else {
            return nil
        }
        
        self.actor = Actor(name: name, id: id)
        self.movieId = movieId
    }
}

struct Movie : JSONDecodable, Hashable, Equatable {
    var title: String
    var releaseDate: String?
    var voteAverage: Int?
    var genreIds: [Int]
    var id: Int
    var hashValue : Int { return self.id }
    
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
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
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



