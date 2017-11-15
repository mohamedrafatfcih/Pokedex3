//
//  Pokemon.swift
//  Pokedex3
//
//  Created by RANDOM on 10/23/17.
//  Copyright © 2017 RANDOM. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description:String!
    private var _type: String!
    private var _defense: String!
    private var _hieght: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoTxt: String!
    private var _pokedexUrl: String!
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokedexUrl = "\(BASE_URL)\(API_URL)\(self._pokedexId!)/"
        
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var description: String {
        return _description
    }
    var type: String {
        return _type
    }
    var defense: String {
        return _defense
    }
    var hieght: String {
        return _hieght
    }
    var wieght: String {
        return _weight
    }
    var attack: String {
        return _attack
    }
    var nextEvoTxt: String {
        return _nextEvoTxt
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        // download using Alimofire goes here
        print(self._pokedexUrl!)
        Alamofire.request(URL(string: self._pokedexUrl)!).responseJSON{ response in
            if response.result.isSuccess {
                if let pokeDic = response.result.value as? Dictionary<String, AnyObject> {
                    if let weight = pokeDic["weight"] as? Int {
                        self._weight = "\(weight)"
                    }
                    if let height = pokeDic["height"] as? Int {
                        self._hieght = "\(height)"
                    }
                    if let types = pokeDic["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                        if let type = types[0]["type"] as? Dictionary<String, AnyObject> {
                            if let name = type["name"] as? String {
                                self._type = "\(name.capitalized)"
                            }
                        }
                    }else {
                        self._type = ""
                    }
                }
            }
            completed()
        }
    }
    
    
}
