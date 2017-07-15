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

protocol Person {
    var name: String { get }
    var movies: [Movie]? { get }
}

struct Actor: Person, JSONDecodable {
    var name: String
    var movies: [Movie]?
    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        self.name = name
    }
}

struct Movie : JSONDecodable {
    var title: String
    var releaseDate: String?
    var voteAverage: Int?
    var id: Int
    
    init(title: String, id: Int) {
        self.title = title
        self.id = id
    }
    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["title"] as? String else {
            return nil
        }
        guard let id = JSON["id"] as? Int else {
            return nil
        }
        self.title = name
        self.id = id
    }
}

struct Genre: JSONDecodable {
    var name: String
    var movies: [Movie]?
    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        self.name = name
    }
}

