//
//  SelectionTableViewCell.swift
//  MovieNight
//
//  Created by Tassia Serrao on 06/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import UIKit

class SelectGenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loveImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
