//
//  PokemonApi.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

struct PokemonApi {
    
    private init() {
        
    }
    
    static let baseUrl = "https://pokeapi.co/api/v2"
    
    static let getListOfPokemon = baseUrl + "/pokemon/?offset=%d&limit=%d"
    
    static let getPokemon = baseUrl + "/pokemon/%d/"
    
    static let getPokemonEvolutions = baseUrl + "/evolution-chain/%d/"
    
    static let getMoves = baseUrl + "/move/"
    
    static let getItems = baseUrl + "/item/"
    
}

