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
    
    func getPokemonList(limit: Int, offset: Int, nextPageUrl: String?, responseValue: @escaping (PokemonListRes) -> Void,  onFailure: (() -> Void)? = nil){
        var url = ""
        
        if let nextPageUrl = nextPageUrl{
            url = nextPageUrl
        }else{
            url = String(format: PokemonApi.getListOfPokemon, offset, limit)
        }
        
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<PokemonListRes>) in
            var pokemonListRes = PokemonListRes()
            
            if let statusCode = response.response?.statusCode{
                switch statusCode {
                case 200:
                    if let value = response.value {
                        pokemonListRes = value
                        responseValue(pokemonListRes)
                    } else {
                        print("error getPokemons -> \(response.error.debugDescription)")
                        onFailure?()
                    }
                 
                default:
                    print("Error request status code: \(statusCode)")
                    onFailure?()
                }
            }else{
                onFailure?()
            }
           
        }
        
    }
    
    func getPokemon(id: Int, responseValue: @escaping (PokemonRes) -> Void, onFailure: (() -> Void)? = nil){
        
        let url = String(format: PokemonApi.getPokemon, id)
        
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<PokemonRes>) in
            var pokemonRes = PokemonRes()
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200:
                    if let value = response.value {
                        pokemonRes = value
                        responseValue(pokemonRes)
                    } else {
                        print("error getPokemon -> \(response.error.debugDescription)")
                        onFailure?()
                    }
                default:
                    print("Error request status code: \(statusCode)")
                    onFailure?()
                }
            }
        
        }
        
    }
    
    
    func getPokemonEvolutions(id: Int, responseValue: @escaping (PokemonEvolutionsRes) -> Void, onFailure: (() -> Void)? = nil){
        
        let url = String(format: PokemonApi.getPokemonEvolutions, id)
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<PokemonEvolutionsRes>) in
            var pokemonRes = PokemonEvolutionsRes()
            if let statusCode = response.response?.statusCode{
                switch statusCode {
                case 200:
                    if let value = response.value {
                        pokemonRes = value
                        responseValue(pokemonRes)
                    } else {
                        print("error getPokemonEvolutions -> \(response.error.debugDescription)")
                        onFailure?()
                    }
                default:
                    print("Error request status code: \(statusCode)")
                    onFailure?()
                }
            }else{
                 onFailure?()
            }
        }
        
    }
    
    func getPokemonMovesList(limit: Int, offset: Int, nextPageUrl: String?, responseValue: @escaping (MovesListRes) -> Void,  onFailure: (() -> Void)? = nil){
        var url = ""
        
        if let nextPageUrl = nextPageUrl{
            url = nextPageUrl
        }else{
            url = String(format: PokemonApi.getMoves, offset, limit)
        }
        
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<MovesListRes>) in
            var listMoves = MovesListRes()
            if let statusCode = response.response?.statusCode{
                switch statusCode {
                case 200:
                    if let value = response.value {
                        listMoves = value
                        responseValue(listMoves)
                    } else {
                        print("error getListMoves -> \(String(describing: response.error))")
                        onFailure?()
                    }
                default:
                    print("Error request status code: \(statusCode)")
                    onFailure?()
                }
            }else{
                onFailure?()
            }
        }
        
    }
    
    func getPokemonItemsList(limit: Int, offset: Int, nextPageUrl: String?, responseValue: @escaping (ListItemsRes) -> Void, onFailure: (() -> Void)? = nil){
        var url = ""
        
        if let nextPageUrl = nextPageUrl{
            url = nextPageUrl
        }else{
            url = String(format: PokemonApi.getItems, offset, limit)
        }
        
        print(url)
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<ListItemsRes>) in
            var listItems = ListItemsRes()
            if let statusCode = response.response?.statusCode{
                switch statusCode {
                case 200:
                    if let value = response.value {
                        listItems = value
                        responseValue(listItems)
                    } else {
                        print("error getListMoves -> \(String(describing: response.error))")
                        onFailure?()
                    }
                default:
                    print("Error request status code: \(statusCode)")
                    onFailure?()
                }
            }else{
                onFailure?()
            }
           
        }
    }
    
    func getMoveById(id: Int, responseValue: @escaping (MoveRes) -> Void, onFailure: (() -> Void)? = nil){
        
        let url = String(format: PokemonApi.getMoveById, id)
        print(url)
        
        ApiAdapter.get.requestPokeDesk(url: url) { (response: AFDataResponse<MoveRes>) in
            var move = MoveRes()
            if let statusCode = response.response?.statusCode{
                switch statusCode {
                case 200:
                    if let value = response.value {
                        move = value
                        responseValue(move)
                    } else {
                        onFailure?()
                        print("error getMoveById -> \(String(describing: response.error))")
                    }
                default:
                    print("Error request status code: \(statusCode)")
                    onFailure?()
                }
                
            }else{
                onFailure?()
            }
          
        }
    }
}
