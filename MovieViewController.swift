//
//  MovieViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 11/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var movieTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieIdCell", for: indexPath) as! MovieTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
