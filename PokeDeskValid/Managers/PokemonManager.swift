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
    
    func getPokemonList(limit: Int, offset: Int, urlNextPage: String?, responseValue: @escaping (PokemonListRes) -> Void){
        pokemonService.getPokemonList(limit: limit, offset: offset, nextPageUrl: urlNextPage, responseValue: responseValue)
    }
    
    func getPokemon(id: Int,responseValue: @escaping (PokemonRes) -> Void){
        pokemonService.getPokemon(id: id, responseValue: responseValue)
    }
    
    func getPokemonEvolutions(id: Int,responseValue: @escaping (PokemonEvolutionsRes) -> Void){
        pokemonService.getPokemonEvolutions(id: id, responseValue: responseValue)
    }
    
    func getListMoves(limit: Int, offset: Int, urlNextPage: String?, responseValue: @escaping (MovesListRes) -> Void){
        pokemonService.getPokemonMovesList(limit: limit, offset: offset, nextPageUrl: urlNextPage, responseValue: responseValue)
    }
    
    func getListItems(limit: Int, offset: Int, urlNextPage: String?, responseValue: @escaping (ListItemsRes) -> Void){
        pokemonService.getPokemonItemsList(limit: limit, offset: offset, nextPageUrl: urlNextPage, responseValue: responseValue)
    }
    
    func getMoveById(id: Int, responseValue: @escaping (MoveRes) -> Void){
         pokemonService.getMoveById(id: id, responseValue: responseValue)
     }
}
