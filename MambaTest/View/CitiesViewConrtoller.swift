//
//  CitiesViewConrtoller.swift
//  MambaTest
//
//  Created by demo on 18.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class CitiesViewConrtoller: UIViewController {
    var tableViewP = UITableView(frame: .zero)
    let activityLabelP = UILabel()
    let activityIndicatorP = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var isFirstAppearance = true //Проверка, первый раз выводится view, или нет
    
    lazy var viewModel = {
        return CitiesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        customiseNavigationBar()
        initViewModel()
        fetchData()
    }
    
    //Эмуляция запроса к серверу
    func fetchData() {
        activityLabelP.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorP.translatesAutoresizingMaskIntoConstraints = false
        
        activityLabelP.text = "Загрузка данных..."
        activityLabelP.font = UIFont(name: "Helvetica", size: 14)
        activityLabelP.textColor = .lightGray
        
        let activityCenterXConstraint = NSLayoutConstraint(item: activityIndicatorP, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1, constant: 0)
        let activityCenterYConstraintr = NSLayoutConstraint(item: activityIndicatorP, attribute: .centerY, relatedBy: .equal, toItem: self.view , attribute: .centerY, multiplier: 1, constant: 0)
        
        let activityLabelTopConstraint = NSLayoutConstraint(item: activityLabelP , attribute: .top, relatedBy: .equal, toItem: activityIndicatorP, attribute: .bottom, multiplier: 1, constant: 20)
        let activityLabelCenterXConstraint = NSLayoutConstraint(item: activityLabelP, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addSubview(activityLabelP)
        self.view.addSubview(activityIndicatorP)
        self.view.addConstraints([activityCenterXConstraint, activityCenterYConstraintr, activityLabelTopConstraint, activityLabelCenterXConstraint])
        
        activityIndicatorP.isHidden = false
        activityLabelP.isHidden = false
        activityIndicatorP.startAnimating()
        
        self.tableViewP.isHidden = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.activityIndicatorP.stopAnimating()
            self.view.removeConstraints([activityCenterXConstraint, activityCenterYConstraintr, activityLabelTopConstraint, activityLabelCenterXConstraint])
            self.activityIndicatorP.removeFromSuperview()
            self.activityLabelP.removeFromSuperview()
            self.tableViewP.isHidden = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    func customiseNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        let leftBarButton = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(showEditing(sender:)))
        let rightBarButton = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addNewCityButtonPressed))
        self.navigationItem.setLeftBarButton(leftBarButton, animated: false)
        self.navigationItem.setRightBarButton(rightBarButton, animated: false)
        self.navigationItem.title = "Города"
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func configureUI() {
        tableViewP.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableViewP)
        self.tableViewP.delegate = self
        self.tableViewP.dataSource = self
        self.tableViewP.allowsSelection = false
        
        self.view.addConstraints ([
            NSLayoutConstraint(item: tableViewP, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableViewP, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableViewP, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableViewP, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
            ])
    }

    @objc func addNewCityButtonPressed() {
        self.tableViewP.isEditing = false
        let nextVC = AddCityViewController()
        nextVC.citiesVCDelegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Костыль что бы убрать подсветку rightBarButtonItem после перехода на другой контроллер. Баг появился в iOS 11.2
    override func viewWillAppear(_ animated: Bool) {
        if isFirstAppearance {
            isFirstAppearance = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func showEditing(sender: UIBarButtonItem) {
        if self.tableViewP.isEditing == true {
            self.tableViewP.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Изменить"
        } else {
            self.tableViewP.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Готово"
        }
    }
    
    func initViewModel() {
        //Инициализация замфкания для обновления tableView
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableViewP.reloadData()
            }
        }
        viewModel.initFetch()
    }
}


