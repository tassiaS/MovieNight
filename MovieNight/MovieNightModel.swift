//
//  Movie.swift
//  MovieNight
//
//  Created by Tassia Serrao on 06/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

//Model

protocol Person {
    var name: String { get }
    var movies: [Movie] { get }
}

struct Actor: Person {
    var name: String
    var movies: [Movie]
}

struct Director: Person {
    var name: String
    var movies: [Movie]
}

struct Movie {
    var title: String
    var releaseDate: String
    var voteAverage: Float
}

struct Genre {
    var name: String
    var movies: [Movie]
}
