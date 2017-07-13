//
//  ApiClient.swift
//  MovieNight
//
//  Created by Tassia Serrao on 13/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

protocol ApiClient {
    func fetchGenres(page: Int, completion: @escaping (APIResult<[Genre]>)-> Void)
    func fetchActors(page: Int, completion: @escaping (APIResult<[Actor]>)-> Void)
    func fetchMovies(page: Int, completion: @escaping (APIResult<[Movie]>)-> Void)
}
