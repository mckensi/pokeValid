//
//  PokemonEvolutionRes.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

class PokemonEvolutionsRes : Codable {
    var chain : Chain?
    var baby_trigger_item : String?
    var id : Int?
    
    enum CodingKeys: String, CodingKey {
        case chain = "chain"
        case baby_trigger_item = "baby_trigger_item"
        case id = "id"
    }
}

class Chain : Codable{
    var evolvesTo : [Evolves_to]?
    var species : Species?
    
    enum CodingKeys: String, CodingKey {
        case evolvesTo = "evolves_to"
        case species = "species"
    }
}

class Evolves_to : Codable{
    var evolvesTo : [Evolves_to]?
    var species : Species?
    
    enum CodingKeys: String, CodingKey {
        case evolvesTo = "evolves_to"
        case species = "species"
    }
}

