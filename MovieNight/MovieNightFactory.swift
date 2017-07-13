//
//  MovieNightFactory.swift
//  MovieNight
//
//  Created by Tassia Serrao on 13/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

class Factory {
    
    class func createRepository() -> Repository {
        let movieNightRepository = MovieNightRepository()
        return movieNightRepository
    }
    
    class func createApiClient() -> ApiClient {
        let movieNightApiCLient = MovieNightApiClient()
        return movieNightApiCLient
    }
}
