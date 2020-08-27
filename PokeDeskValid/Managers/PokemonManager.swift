//
//  PokemonManager.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

class PokemonManager: NSObject {
    static let get = PokemonManager()
    
    private let pokemonService = PokemonService.get
    
    func getPokemonList(limit: Int, offset: Int, urlNextPage: String?, responseValue: @escaping (PokemonListRes) -> Void, onFailure: (() -> Void)? = nil){
        pokemonService.getPokemonList(limit: limit, offset: offset, nextPageUrl: urlNextPage, responseValue: responseValue, onFailure: onFailure)
    }
    
    func getPokemon(id: Int,responseValue: @escaping (PokemonRes) -> Void, onFailure: (() -> Void)? = nil){
        pokemonService.getPokemon(id: id, responseValue: responseValue, onFailure: onFailure)
    }
    
    func getPokemonEvolutions(id: Int,responseValue: @escaping (PokemonEvolutionsRes) -> Void, onFailure: (() -> Void)? = nil){
        pokemonService.getPokemonEvolutions(id: id, responseValue: responseValue, onFailure: onFailure)
    }
    
    func getListMoves(limit: Int, offset: Int, urlNextPage: String?, responseValue: @escaping (MovesListRes) -> Void, onFailure: (() -> Void)? = nil){
        pokemonService.getPokemonMovesList(limit: limit, offset: offset, nextPageUrl: urlNextPage, responseValue: responseValue, onFailure: onFailure)
    }
    
    func getListItems(limit: Int, offset: Int, urlNextPage: String?, responseValue: @escaping (ListItemsRes) -> Void,  onFailure: (() -> Void)? = nil){
        pokemonService.getPokemonItemsList(limit: limit, offset: offset, nextPageUrl: urlNextPage, responseValue: responseValue, onFailure: onFailure)
    }
    
    func getMoveById(id: Int, responseValue: @escaping (MoveRes) -> Void, onFailure: (() -> Void)? = nil){
         pokemonService.getMoveById(id: id, responseValue: responseValue, onFailure: onFailure)
     }
}
