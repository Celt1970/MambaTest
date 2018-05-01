//
//  ViewController.swift
//  MambaTest
//
//  Created by demo on 18.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let nameLabel = UILabel()
    let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        configureUI()
    }
    
    func configureUI(){
        self.view.backgroundColor = .white
        nameLabel.text = "Борисов Юрий Евгеньевич"
        nextButton.setTitle("Начать", for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.addTarget(self, action: #selector(goToTableViewButton(_:)), for: .touchUpInside)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(nextButton)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1, constant:0),
            NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view , attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nextButton, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1 , constant: 0),
            NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: -100)
            ])
    }

   
    @objc func goToTableViewButton(_ sender: Any) {
        let nextVC = CitiesViewConrtoller()
        nextVC.view.backgroundColor = .white
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

}

