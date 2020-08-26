//
//  PokemonMovesViewModel.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//
import Foundation

class PokemonMovesViewModel {
    var manager = PokemonManager.get
    var pokemonMovesListRes: ((MovesListRes) -> Void)?
    var moveRes: ((MoveRes) -> Void)?
    
    func getListMoves(limit: Int, offset: Int, urlNextPage: String?){
        if let responseValue = pokemonMovesListRes {
            manager.getListMoves(limit: limit, offset: offset, urlNextPage: urlNextPage, responseValue: responseValue)
        }
    }
    
    func getMoveById(id: Int){
           if let responseValue = moveRes {
               manager.getMoveById(id: id, responseValue: responseValue)
           }
       }
}

