//
//  MoveRes.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 26/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation

class MoveRes: Codable {
    var name: String?
    var acuracy: Int?
    var power: Int?
    var pp: Int?
    var type: TypeMove?
}

class TypeMove: Codable{
    var name: String?
    var url: String?
}
