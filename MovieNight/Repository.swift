//
//  File.swift
//  MovieNight
//
//  Created by Tassia Serrao on 13/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation

protocol Repository {
    var userDefault: UserDefaults { get }
    
    func save(dictionary: [Int: String], forKey key: String)
    func retrieveDictionary(withKey key: String) -> [Int: String]?
}

extension Repository {
    func save(dictionary: [Int: String], forKey key: String) {
        let archiver = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        userDefault.set(archiver, forKey: key)
    }
    
    func retrieveDictionary(withKey key: String) -> [Int: String]? {
        
        // Check if data exists
        guard let data = UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        
        // Check if retrieved data has correct type
        guard let retrievedData = data as? Data else {
            return nil
        }
        
        // Unarchive data
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
        return unarchivedObject as? [Int: String]
    }
}
