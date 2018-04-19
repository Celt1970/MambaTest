//
//  AddCityViewController.swift
//  MambaTest
//
//  Created by demo on 19.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityPopulationTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var viewModel: AddCityViewModel = {
        return AddCityViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.accessibilityLabel = "hohoho"
        configureUI()
        initVM()
    }
    
    func initVM(){
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
    }
    
    func configureUI(){
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.navigationController?.navigationBar.isHidden = false
        let leftBarButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(canselButtonPressed))
        let rightBarButton = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        
        self.navigationItem.setRightBarButton(rightBarButton, animated: false)
        self.navigationItem.setLeftBarButton(leftBarButton, animated: false)
        self.navigationItem.title = "Новый город"
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        viewModel.getCityFromData(name: cityNameTextField.text!, population: cityPopulationTextField.text!)
      
        guard let previousVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? CitiesViewConrtoller else {
            print("Wrong ViewController!")
            return
        }
        
        guard let city = viewModel.city else {
            print("City is nil")
            return
        }
        
        previousVC.viewModel.addCity(city)
        
        fetchData(){ [weak self] in
            self?.navigationController?.popToViewController(previousVC, animated: true)
        }
    }
    
    func fetchData( completion: @escaping () -> ()){
        self.addButton.isHidden = true
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        self.activityIndicator.isHidden = false
        self.activityLabel.isHidden = false
        self.activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.activityLabel.isHidden = true

            self.addButton.isHidden = false
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true

            completion()
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
   
    @objc func canselButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
