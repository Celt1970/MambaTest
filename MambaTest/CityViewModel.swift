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
                                  City(name: "Lipetsk", people: 650000)].sorted(by: {$0.name < $1.name})
    
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
