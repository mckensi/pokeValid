//
//  HomeViewModel.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

class HomeViewModel{
    private let pokemonManager = PokemonManager.get
    
    var pokemonListRes: ((PokemonListRes) -> Void)?
    

    func getPokemonList(limit: Int, offset: Int, urlNextPage: String?){
        if let responseValue = pokemonListRes {
            pokemonManager.getPokemonList(limit: limit, offset: offset, urlNextPage: urlNextPage, responseValue: responseValue)
        }
    }
}
