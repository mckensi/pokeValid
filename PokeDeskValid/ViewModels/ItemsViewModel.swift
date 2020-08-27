//
//  ItemsViewModel.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

class ItemsViewModel {
    
    var manager = PokemonManager.get
    var itemsListRes: ((ListItemsRes) -> Void)?
    var onFailure: (() -> Void)?
     
    func getListMoves(limit: Int, offset: Int, urlNextPage: String?){
        if let responseValue = itemsListRes {
            manager.getListItems(limit: limit, offset: offset, urlNextPage: urlNextPage, responseValue: responseValue, onFailure: onFailure)
        }
    }
}

