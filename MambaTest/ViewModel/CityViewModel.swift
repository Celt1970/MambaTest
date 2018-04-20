//
//  CityViewModel.swift
//  MambaTest
//
//  Created by demo on 18.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation

class CitiesViewModel {
    private var cities: [City] = [City(name: "Москва", people: 12000000),
                                  City(name: "Санкт-Петербург", people: 5191000),
                                  City(name: "Чита", people: 343000),
                                  City(name: "Пермь", people: 991000),
                                  City(name: "Сургут", people: 348000),
                                  City(name: "Мурманск", people: 301000),
                                  City(name: "Липецк", people: 510000)]{
        didSet{
            //При изменении cities, филтруем по населению и обновляем cellViewModels
            cities = cities.sorted(by: {$0.people > $1.people})
            self.initFetch()
        }
    }
    
    private var cellViewModels: [CityCellViewModel] = [CityCellViewModel]() {
        didSet {
            //При изменении перезагружаем tableView
            self.reloadTableViewClosure?()
        }
    }
    
    var heightForRow: Double{
        return 70.0
    }
    
    var numberOfSections: Int{
        return 1
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (()->())?

    
    func initFetch() {
        self.processFetchedCities(cities: cities)
    }
    
    func addCity(_ city: City) {
        cities.append(city)
    }
    
    func removeCity(at index: Int){
        cities.remove(at: index)
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> CityCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( city: City ) -> CityCellViewModel {
        return CityCellViewModel(peopleAmount: String(city.people), cityName: city.name)
    }
   
    //проходит по массиву cities, и обновляет cellViewModels
    private func processFetchedCities( cities: [City] ) {
        var vms = [CityCellViewModel]()
        for city in cities {
            vms.append( createCellViewModel(city: city) )
        }
        self.cellViewModels = vms
    }
}
