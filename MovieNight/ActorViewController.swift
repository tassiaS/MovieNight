//
//  ActorViewController.swift
//  MovieNight
//
//  Created by Tassia Serrao on 09/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class ActorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var actorTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actorTableView.delegate = self
        actorTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorIdCell", for: indexPath) as! ActorTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
