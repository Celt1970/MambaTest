//
//  CitiesCell.swift
//  MambaTest
//
//  Created by demo on 18.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
//    @IBOutlet weak var peopleAmountLabel: UILabel!
//    @IBOutlet weak var cityNameLabel: UILabel!
    
    private let name = UILabel()
    private let population = UILabel()
    let cityNameLabelP = UILabel()
    let populationLabelP = UILabel()
    
    var nameAndPopulationStackView = UIStackView()
    var cityNameAndPopulationLabelStackView = UIStackView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        name.text = "Город:"
        population.text = "Население:"
        
        nameAndPopulationStackView.addArrangedSubview(name)
        nameAndPopulationStackView.addArrangedSubview(population)
        
        cityNameAndPopulationLabelStackView.addArrangedSubview(cityNameLabelP)
        cityNameAndPopulationLabelStackView.addArrangedSubview(populationLabelP)
        
        nameAndPopulationStackView.translatesAutoresizingMaskIntoConstraints = false
        cityNameAndPopulationLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        nameAndPopulationStackView.axis = .vertical
        nameAndPopulationStackView.distribution = .equalCentering
        nameAndPopulationStackView.alignment = .leading
        
        cityNameAndPopulationLabelStackView.axis = .vertical
        cityNameAndPopulationLabelStackView.distribution = .equalCentering
        cityNameAndPopulationLabelStackView.alignment = .trailing
        
        contentView.addSubview(nameAndPopulationStackView)
        contentView.addSubview(cityNameAndPopulationLabelStackView)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: .alignAllFirstBaseline, metrics: nil, views: ["view" : nameAndPopulationStackView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-[view]", options: .alignAllFirstBaseline, metrics: nil, views: ["view" : nameAndPopulationStackView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: .alignAllFirstBaseline, metrics: nil, views: ["view" : cityNameAndPopulationLabelStackView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[view]-|", options: .alignAllFirstBaseline, metrics: nil, views: ["view" : cityNameAndPopulationLabelStackView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
