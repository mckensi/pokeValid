//
//  PokemonListRes.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

// MARK: - PokemonList
class PokemonListRes: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [PokemonData]?
}

// MARK: - Result
class PokemonData: Codable {
    var name: String?
    var url: String?
}

