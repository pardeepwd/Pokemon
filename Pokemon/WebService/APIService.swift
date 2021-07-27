//
//  APIService.swift
//  Pokemon
//
//  Created by MAacbook Mathur on 20/05/20.
//  Copyright © 2020 Abhilash Mathur. All rights reserved.
//

import Foundation
import SystemConfiguration

class APIService :  NSObject {
    
    func getPokemons(apiUrl: String,isShowloader:Bool = true, parameters: [String: Any]? = nil,completion: @escaping (Pokemon?,Bool) -> () ) {
        print("hitting:" , apiUrl)
        print("parameters:",parameters ?? ["":""])
        if !isConnectedToNetwork(){
            Utility.shared.displayAlert(title: "", message: "You are not connected with internet", control: ["Ok"])
            completion(nil,true)
            return
        }
        
        guard let url = URL(string: apiUrl) else {return}
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                //Utility.shared.hide_loader()
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                guard let data = data else {return}
                
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                print("response",jsonObject as Any)
                Persistance.savePokemonJson(jsonToSave: jsonObject!)

                do {
                    let pokemonData = try JSONDecoder().decode(Pokemon.self, from: data)
                    var apicount = 0
                    for pokemon in pokemonData.results {
                        
                        guard let newURL = URL(string: pokemon.url) else { return }
                        URLSession.shared.dataTask(with: newURL) {(data, response, error) in
                            apicount += 1
                            guard let data = data else { return }
                            
                            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                            //print("response",jsonObject as Any)
                            Persistance.savePokemonDetailJson(jsonToSave: jsonObject!)

                            do {
                                let load = try JSONDecoder().decode(PokemonDetail.self, from: data)
                                pokemon.pokemonDetail = load
//                                print("ability",load.abilities[0].ability)
//                                print("image",load.sprites.frontShiny ?? "")
                            } catch let jsonErr {
                                print("Error serializing JSON:", jsonErr)
                            }
                            
                            if apicount == pokemonData.results.count {
                                completion(pokemonData,false)
                            }
                            
                        }.resume()
                    }
                    
                } catch let jsonErr {
                    print(jsonErr)
                }
            }
        }.resume()
    }
}

//MARK: - Check Internet
func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    if(defaultRouteReachability == nil){
        return false
    }
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}
