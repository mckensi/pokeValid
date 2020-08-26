//
//  PokemonTableViewCell.swift
//  PokeDeskApp
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet var imgViewPokemon: UIImageView!

    @IBOutlet var lblTitle: UILabel!
    
    var pokemon : PokemonData? {
        didSet{
            lblTitle?.text = pokemon?.name?.capitalizingFirstLetter() ?? ""
            let charactersUrl = pokemon?.url?.split(separator: "/")
            let idPokemon = charactersUrl?.last ?? ""
            DispatchQueue.main.async {
                if let url = URL(string: "\(PokemonImageApi.baseImageUrl)\(idPokemon).png") {
                    self.imageView?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (result) in
                            self.setNeedsLayout()
                    })
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
