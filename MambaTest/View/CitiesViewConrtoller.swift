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
    
    var isFirstAppearance = true
    
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
    
    @objc func addNewCityButtonPressed(){
        self.tableView.isEditing = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "AddCityViewController") as! AddCityViewController
        nextVC.citiesVCDelegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: Костыль что бы убрать подсветку rightBarButtonItem после перехода на другой контроллер. Баг появился в iOS 11.2
        if isFirstAppearance{
            isFirstAppearance = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
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

protocol CitiesViewDelegate{
    func addCityToViewModel(city: City)
}


