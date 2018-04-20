//
//  ExtensionCitiesVC.swift
//  MambaTest
//
//  Created by demo on 20.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import Foundation
import UIKit

extension CitiesViewConrtoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCellIdentifier", for: indexPath) as? CityCell else {
            fatalError("Cell doesn't exist!")
        }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cityNameLabel.text = cellVM.cityName
        cell.peopleAmountLabel.text = cellVM.peopleAmount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCity(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
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
}
