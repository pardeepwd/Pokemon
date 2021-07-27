//
//  Persistance.swift
//  Pokemon
//
//  Created by ABC on 22/07/21.
//

import Foundation

class Persistance {
    
    static func savePokemonJson(jsonToSave:Any) {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Pokemon.json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonToSave, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    static func savePokemonDetailJson(jsonToSave:Any) {
        
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("PokemonDetail.json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonToSave, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    static func retrievePokemonFromJson() -> Data? {
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Pokemon.json")
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            return data
            //            guard let pokemonDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return [:]}
            //            print("pokemonDict",pokemonDict)
            //            return pokemonDict
        } catch {
            print(error)
            return nil
        }
    }
    
    static func retrievePokemonDetailFromJson() -> Data? {
        
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("PokemonDetail.json")
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            //return data
              guard let pokemonDetailDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return nil}
             print("pokemonDetailDict",pokemonDetailDict)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
}

extension UserDefaults {

   func save<T:Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           }else {
               print("Couldnt decode object")
               return nil
           }
       }else {
           print("Couldnt find key")
           return nil
       }
   }

}

//extension UserDefaults {
//
//    func set<T: Encodable>(encodable: T, forKey key: String) {
//        if let data = try? JSONEncoder().encode(encodable) {
//            set(data, forKey: key)
//        }
//    }
//
//    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
//        if let data = object(forKey: key) as? Data,
//            let value = try? JSONDecoder().decode(type, from: data) {
//            return value
//        }
//        return nil
//    }
//}
