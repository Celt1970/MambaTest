//
//  CitiesViewConrtoller.swift
//  MambaTest
//
//  Created by demo on 18.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class CitiesViewConrtoller: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel = {
        return CitiesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        customiseNavigationBar()
        styleUI()
        initViewModel()
        print(viewModel.numberOfCells)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func customiseNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        let leftBarButton = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: nil)
        let rightBarButton = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(goToPrevioousController))
        
        self.navigationItem.setLeftBarButton(leftBarButton, animated: false)
        self.navigationItem.setRightBarButton(rightBarButton, animated: false)
        self.navigationItem.title = "Города"
        self.navigationController?.navigationBar.isTranslucent = false

    }
    @objc func goToPrevioousController(){
        self.navigationController?.popViewController(animated: true)
    }
    func styleUI(){
//
        self.tableView.backgroundColor = UIColor.red
    }
    
    func initViewModel() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.initFetch()
    }
}



extension CitiesViewConrtoller: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
