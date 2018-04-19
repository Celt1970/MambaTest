//
//  CityViewModel.swift
//  MambaTest
//
//  Created by demo on 18.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation

class CitiesViewModel {
    private var cities: [City] = [City(name: "Moscow", people: 15000000),
                                  City(name: "Saint-Petersburg", people: 10000000),
                                  City(name: "Lipetsk", people: 650000)]{
        didSet{
            cities = cities.sorted(by: {$0.people > $1.people})
            self.initFetch()
        }
    }
    
    private var cellViewModels: [CityCellViewModel] = [CityCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func initFetch() {
        self.isLoading = true
        self.processFetchedCities(cities: cities)
    }
    
    func addCity(_ name: String, withPeople: String) {
        guard let population = Int(withPeople.replacingOccurrences(of: " ", with: "")) else { return }
        let city = City(name: name, people: population)
        cities.append(city)
    }
    
    func removeCity(at index: Int){
        cities.remove(at: index)
    }
    
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?

    func getCellViewModel( at indexPath: IndexPath ) -> CityCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( city: City ) -> CityCellViewModel {
        return CityCellViewModel(peopleAmount: String(city.people), cityName: city.name)
    }
    private func processFetchedCities( cities: [City] ) {
//        self.cities = cities
        var vms = [CityCellViewModel]()
        for city in cities {
            vms.append( createCellViewModel(city: city) )
        }
        self.cellViewModels = vms
    }
}
