//
//  PokemonService.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

import Alamofire

class PokemonService {
    
    public static let get = PokemonService()
    
    public init() {}
    
    func getPokemonList(limit: Int, offset: Int, nextPageUrl: String?, responseValue: @escaping (PokemonListRes) -> Void){
        var url = ""
        
        if let nextPageUrl = nextPageUrl{
            url = nextPageUrl
        }else{
            url = String(format: PokemonApi.getListOfPokemon, offset, limit)
        }
        
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<PokemonListRes>) in
            var pokemonListRes = PokemonListRes()
            if let value = response.value {
                pokemonListRes = value
            } else {
                print("error getPokemons -> \(response.error.debugDescription)")
            }
            responseValue(pokemonListRes)
        }
        
    }
    
    func getPokemon(id: Int, responseValue: @escaping (PokemonRes) -> Void){
        
        let url = String(format: PokemonApi.getPokemon, id)
        
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<PokemonRes>) in
            var pokemonRes = PokemonRes()
            if let value = response.value {
                pokemonRes = value
            } else {
                print("error getPokemon -> \(response.error.debugDescription)")
            }
            responseValue(pokemonRes)
        }
        
    }
    
    
    func getPokemonEvolutions(id: Int, responseValue: @escaping (PokemonEvolutionsRes) -> Void){
        
        let url = String(format: PokemonApi.getPokemonEvolutions, id)
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<PokemonEvolutionsRes>) in
            var pokemonRes = PokemonEvolutionsRes()
            if let value = response.value {
                pokemonRes = value
            } else {
                print("error getPokemonEvolutions -> \(response.error.debugDescription)")
            }
            responseValue(pokemonRes)
        }
        
    }
    
    func getPokemonMovesList(limit: Int, offset: Int, nextPageUrl: String?, responseValue: @escaping (MovesListRes) -> Void){
        var url = ""
        
        if let nextPageUrl = nextPageUrl{
            url = nextPageUrl
        }else{
            url = String(format: PokemonApi.getMoves, offset, limit)
        }
        
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<MovesListRes>) in
            var listMoves = MovesListRes()
            if let value = response.value {
                listMoves = value
            } else {
                print("error getListMoves -> \(String(describing: response.error))")
            }
            responseValue(listMoves)
        }
        
    }
    
    func getPokemonItemsList(limit: Int, offset: Int, nextPageUrl: String?, responseValue: @escaping (ListItemsRes) -> Void){
        var url = ""
        
        if let nextPageUrl = nextPageUrl{
            url = nextPageUrl
        }else{
            url = String(format: PokemonApi.getItems, offset, limit)
        }
        
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<ListItemsRes>) in
            var listItems = ListItemsRes()
            if let value = response.value {
                listItems = value
            } else {
                print("error getListMoves -> \(String(describing: response.error))")
            }
            responseValue(listItems)
        }
    }
    
    func getMoveById(id: Int, responseValue: @escaping (MoveRes) -> Void){
        
        let url = String(format: PokemonApi.getMoveById, id)
        print(url)
        
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<MoveRes>) in
            var move = MoveRes()
            if let value = response.value {
                move = value
            } else {
                print("error getMoveById -> \(String(describing: response.error))")
            }
            responseValue(move)
        }
    }
}
