//
//  PokemonDetailViewModel.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

class PokemonDetailViewModel{
    
    private let pokemonManager = PokemonManager.get
    
    var pokemonRes: ((PokemonRes) -> Void)?
    var pokemonEvolutionsRes: ((PokemonEvolutionsRes) -> Void)?
    
    func getPokemon(id: Int){
        if let responseValue = pokemonRes {
            pokemonManager.getPokemon(id: id, responseValue: responseValue)
        }
    }
    
    func getPokemonEvolutions(id: Int){
        if let responseValue = pokemonEvolutionsRes {
            pokemonManager.getPokemonEvolutions(id: id, responseValue: responseValue)
        }
    }
}
