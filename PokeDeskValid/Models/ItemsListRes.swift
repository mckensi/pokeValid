//
//  ItemsListRes.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

class ListItemsRes : Codable{
    var count : Int?
    var next : String?
    var previus : String?
    var results : [Species]?
}

