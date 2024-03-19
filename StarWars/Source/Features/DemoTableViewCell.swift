//
//  DemoTableViewCell.swift
//  StarWars
//
//  Created by Anuradha Andriesz on 2024-03-14.
//

import UIKit

class DemoTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
   
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
