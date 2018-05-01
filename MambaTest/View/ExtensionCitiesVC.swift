//
//  ExtensionCitiesVC.swift
//  MambaTest
//
//  Created by demo on 20.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation
import UIKit


protocol CitiesViewDelegate {
    func addCityToViewModel(city: City)
    func checkIsCityAdded(city: City) -> Bool
}

extension CitiesViewConrtoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CityCell(style: .default, reuseIdentifier: "cityCell")

        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cityNameLabelP.text = cellVM.cityName
        cell.populationLabelP.text = cellVM.peopleAmount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCity(at: indexPath.row)
            self.tableViewP.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRow)
    }
}

extension CitiesViewConrtoller: CitiesViewDelegate {
    func addCityToViewModel(city: City) {
        self.viewModel.addCity(city)
    }
    func checkIsCityAdded(city: City) -> Bool {
       return viewModel.checkIsCityAdded(city: city)
    }
}
