//
//  AddCityViewModel.swift
//  MambaTest
//
//  Created by Yuriy borisov on 19.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation

class AddCityViewModel {
    fileprivate var newCity: City?
    
    //При изменении запускает замыкание
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var city: City?{
        return newCity
    }
    
    var showAlertClosure: (()->())?
    
    func getCityFromData(name: String, population: String){
        if checkInputData(name: name, population: population) {
            self.newCity = City(name: name.capitalized, people: Int(population)!)
        }else{
            return
        }
    }
    
    //Проверяем корректность введенных данных
    private func checkInputData(name: String, population: String) -> Bool{
        if name.trimmingCharacters(in: .whitespaces).isEmpty  ||
        population.trimmingCharacters(in: .whitespaces).isEmpty  {
            self.alertMessage = "Оба поля должны быть заполнены!"
            return false
        }
        guard Int(population) != nil else {
            self.alertMessage = "Население может быть только целым числом!"
            return false
        }
        return true
    }
}
