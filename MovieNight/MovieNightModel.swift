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


protocol People {
    var name: String { get }
    var movies: [Movie]? { get }
}

struct Actor: People, JSONDecodable {
    var name: String
    var movies: [Movie]?
    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        self.name = name
    }
}

struct Director: People {
    var name: String
    var movies: [Movie]?
}

struct Movie {
    var title: String
    var releaseDate: String
    var voteAverage: Int
}

struct Genre: JSONDecodable{
    var name: String
    var movies: [Movie]?
    
    init?(JSON: [String: AnyObject]) {
        guard let name = JSON["name"] as? String else {
            return nil
        }
        self.name = name
    }
}
