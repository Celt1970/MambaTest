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
    @IBOutlet weak var activityLabel: UILabel!
    
    var isNotFirstAppearance = false
    
    lazy var viewModel = {
        return CitiesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        
        customiseNavigationBar()
        initViewModel()
        fetchData()

    }
    
    func fetchData(){
        self.activityIndicator.isHidden = false
        self.tableView.isHidden = true
        self.activityLabel.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false

        self.activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.activityLabel.isHidden = true

            self.tableView.isHidden = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    func customiseNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        let leftBarButton = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(showEditing(sender:)))
        let rightBarButton = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addNewCityButtonPressed))
        
        self.navigationItem.setLeftBarButton(leftBarButton, animated: false)
        self.navigationItem.setRightBarButton(rightBarButton, animated: false)
        self.navigationItem.title = "Города"
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    @objc func goToPrevioousController(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addNewCityButtonPressed(){
        self.tableView.isEditing = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "AddCityViewController") as! AddCityViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //Костыль что бы убрать подсветку rightBarButtonItem после перехода на другой контроллер. Баг появился в iOS 11.2
        if isNotFirstAppearance{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            isNotFirstAppearance = true
        }
        
    }
    
    @objc func showEditing(sender: UIBarButtonItem){
        if self.tableView.isEditing == true {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Изменить"
        }else{
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Готово"
        }
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
        if editingStyle == .delete{
            viewModel.removeCity(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRow)
    }
    
}
