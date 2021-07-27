//
//  EmployeesViewModel.swift
//  MVVM_New
//
//  Created by Abhilash Mathur on 20/05/20.
//  Copyright © 2020 Abhilash Mathur. All rights reserved.
//

import Foundation

class PokemonViewModel : NSObject {
    
    private var apiService : APIService!
    
    private(set) var pokemonData : Pokemon! {
        didSet {
            self.bindDataToController()
        }
    }
    
    var bindDataToController : (() -> ()) = {}
    var bindErrorToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    func callFuncToGetPokemonData(url:String,showLoader:Bool) {
        self.apiService.getPokemons(apiUrl: url, isShowloader:showLoader, parameters: [:]) { (data,isError) in
            if isError {
                self.bindErrorToController()
            }else{
                self.pokemonData = data
            }
        }
    }
}
