//
//  Pokemon.swift
//  Pokemon
//
//  Created by ABC on 21/07/21.
//

import Foundation

// MARK: - Welcome
class Pokemon: NSObject,NSCoding,Codable {
    let count: Int
    let next: String
    let previous: String?
    var results: [PokemonData]
    
    init(count: Int, next: String, previous: String, results:[PokemonData]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let count = decoder.decodeObject(forKey: "count") as? Int,
              let next = decoder.decodeObject(forKey: "next") as? String,
              let previous = decoder.decodeObject(forKey: "previous") as? String,
              let results = decoder.decodeObject(forKey: "results") as? [PokemonData]
        else { return nil }
        
        self.init(count: count, next: next, previous:previous, results:results)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.count, forKey: "count")
        coder.encode(self.next, forKey: "next")
        coder.encode(self.previous, forKey: "previous")
        coder.encode(self.results, forKey: "results")
    }
}

// MARK: - Datum
class PokemonData: NSObject,NSCoding,Codable {
    let name : String
    let url : String
    var pokemonDetail : PokemonDetail?
    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case url
//        case pokemonDetail
//    }
    
    init(name: String, url: String, pokemonDetail:PokemonDetail?) {
        self.name = name
        self.url = url
        if pokemonDetail != nil {
            self.pokemonDetail = pokemonDetail
        }
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
              let url = decoder.decodeObject(forKey: "url") as? String,
              let pokemonDetail = decoder.decodeObject(forKey: "pokemonDetail") as? PokemonDetail
        else { return nil }
        self.init(name: name, url: url, pokemonDetail:pokemonDetail)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.url, forKey: "url")
        coder.encode(self.pokemonDetail, forKey: "pokemonDetail")
    }

}

class PokemonDetail : NSObject,NSCoding,Codable  {
    
    let abilities: [PokemonAbilities]
    let baseExperience : Int
    let sprites : PokemonImages!
    
    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case sprites
    }
    
    init(abilities: [PokemonAbilities], baseExperience: Int, sprites:PokemonImages) {
        self.abilities = abilities
        self.baseExperience = baseExperience
        self.sprites = sprites
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let abilities = decoder.decodeObject(forKey: "abilities") as? [PokemonAbilities],
              let baseExperience = decoder.decodeObject(forKey: "baseExperience") as? Int,
              let sprites = decoder.decodeObject(forKey: "sprites") as? PokemonImages
        else { return nil }
        self.init(abilities: abilities, baseExperience: baseExperience, sprites:sprites)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.abilities, forKey: "abilities")
        coder.encode(self.baseExperience, forKey: "baseExperience")
        coder.encode(self.sprites, forKey: "sprites")
    }
    
}

class PokemonAbilities : NSObject,NSCoding,Codable {
    
    let ability: PokemonData2
    
    init(ability: PokemonData2) {
        self.ability = ability
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let ability = decoder.decodeObject(forKey: "ability") as? PokemonData2
        else { return nil }
        self.init(ability: ability)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.ability, forKey: "ability")
    }
}

class PokemonData2 : NSObject,NSCoding,Codable {
    
    let name : String
    let url : String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
              let url = decoder.decodeObject(forKey: "url") as? String
        else { return nil }
        self.init(name: name, url: url)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.url, forKey: "url")
    }
}

class PokemonImages : NSObject,NSCoding,Codable {
    
    let backShiny: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case backShiny = "back_shiny"
        case frontShiny = "front_shiny"
    }
    
    init(backShiny: String?, frontShiny: String?) {
        self.backShiny = backShiny ?? ""
        self.frontShiny = frontShiny ?? ""
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let backShiny = decoder.decodeObject(forKey: "backShiny") as? String,
              let frontShiny = decoder.decodeObject(forKey: "frontShiny") as? String
        else { return nil }
        self.init(backShiny: backShiny, frontShiny: frontShiny)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.backShiny, forKey: "backShiny")
        coder.encode(self.frontShiny, forKey: "frontShiny")
    }
    

}


