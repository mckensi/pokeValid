//
//  PokemonTableViewCell.swift
//  PokeDeskApp
//
//  Created by Daniel Murcia on 10/26/19.
//  Copyright © 2019 Daniel Steven Murcia Almanza. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet var imgViewPokemon: UIImageView!

    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
