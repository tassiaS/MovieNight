//
//  DirectorViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 09/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class DirectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var directorTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        directorTableView.delegate = self
        directorTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directorIdCell", for: indexPath) as! DirectorTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
