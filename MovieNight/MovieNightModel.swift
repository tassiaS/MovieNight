//
//  Movie.swift
//  MovieNight
//
//  Created by Tassia Serrao on 06/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

//Model

protocol People {
    var name: String { get }
    var movies: [Movie] { get }
}

struct Actor: People {
    var name: String
    var movies: [Movie]
}

struct Director: People {
    var name: String
    var movies: [Movie]
}

struct Movie {
    var title: String
    var releaseDate: String
    var voteAverage: Int
}

struct Genre {
    var name: String
    var movies: [Movie]
}
