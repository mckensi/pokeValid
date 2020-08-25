//
//  PokemonEvolutionTableViewCell.swift
//  PokeDeskApp
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import UIKit

class PokemonEvolutionTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewFirstEvolution: UIImageView!
    @IBOutlet weak var imgViewSecondEvolution: UIImageView!
    @IBOutlet weak var lblLevel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
