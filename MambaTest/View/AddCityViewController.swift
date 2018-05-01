//
//  AddCityViewController.swift
//  MambaTest
//
//  Created by demo on 19.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    
    let activityIndicatorP = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let activityLabelP = UILabel()
    let addButtonP = UIButton()
    let cityNameTextFieldP = UITextField()
    let cityPopulationTextFieldP = UITextField()
    var textFieldsStackView = UIStackView()
    
    var citiesVCDelegate: CitiesViewDelegate?
    var viewModel: AddCityViewModel = {
        return AddCityViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGestures()
        initVM()
    }
    
    func initVM() {
        //Инициализируем замыкание для вывода UIAlertView
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        let leftBarButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(canselButtonPressed))
        let rightBarButton = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        self.navigationItem.setRightBarButton(rightBarButton, animated: false)
        self.navigationItem.setLeftBarButton(leftBarButton, animated: false)
        self.navigationItem.title = "Новый город"
        self.navigationController?.navigationBar.isTranslucent = false
        
        cityNameTextFieldP.borderStyle = .roundedRect
        cityPopulationTextFieldP.borderStyle = .roundedRect
        let placeholderAttributes: [NSAttributedStringKey : NSObject] = [NSAttributedStringKey.foregroundColor  : UIColor.gray, NSAttributedStringKey.font : UIFont(name: "Helvetica", size: 15)!]
        
        cityNameTextFieldP.attributedPlaceholder = NSAttributedString(string: "Введите имя города...", attributes: placeholderAttributes)
        
        cityPopulationTextFieldP.attributedPlaceholder = NSAttributedString(string: "И его население...", attributes: placeholderAttributes)
        
        cityNameTextFieldP.addTarget(self, action: #selector(addButtonPressed(_:)), for: .primaryActionTriggered)
        cityPopulationTextFieldP.addTarget(self, action: #selector(addButtonPressed(_:)), for: .primaryActionTriggered)
        
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.addArrangedSubview(cityNameTextFieldP)
        textFieldsStackView.addArrangedSubview(cityPopulationTextFieldP)
        
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fillEqually
        textFieldsStackView.alignment = .fill
        textFieldsStackView.spacing = 20
        self.view.addSubview(textFieldsStackView)
        
        addButtonP.setTitle("Добавить", for: .normal)
        addButtonP.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        addButtonP.setTitleColor(.blue, for: .normal)
        addButtonP.translatesAutoresizingMaskIntoConstraints = false
        addButtonP.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(addButtonP)
        self.view.addConstraints([
            NSLayoutConstraint(item: addButtonP, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: -150),
            NSLayoutConstraint(item: addButtonP, attribute: .centerX, relatedBy: .equal, toItem: self.view , attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textFieldsStackView, attribute: .top, relatedBy: .equal, toItem: self.view , attribute: .top, multiplier: 1, constant: 150),
            NSLayoutConstraint(item: textFieldsStackView, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: textFieldsStackView, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: textFieldsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
            ])
    }
    
    //Добавляем возможность убрать клавиатуру коснувшись экрана
    func configureGestures() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addButtonPressed(_ sender: Any) {
        guard self.citiesVCDelegate != nil else { return }
        viewModel.getCityFromData(name: cityNameTextFieldP.text!, population: cityPopulationTextFieldP.text!, delegat: self.citiesVCDelegate!)
        
        guard let city = viewModel.city else {
            print("City is nil")
            return
        }
        citiesVCDelegate?.addCityToViewModel(city: city)//передаем делегату город
        self.view.endEditing(true)
        fetchData() { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //Имитируем запрос к серверу
    func fetchData( completion: @escaping () -> ()) {
        
        activityLabelP.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorP.translatesAutoresizingMaskIntoConstraints = false
        activityLabelP.text = "Отправка данных..."
        activityLabelP.font = UIFont(name: "Helvetica", size: 14)
        activityLabelP.textColor = .lightGray
        
        let activityCenterXConstraint = NSLayoutConstraint(item: activityIndicatorP, attribute: .centerX, relatedBy: .equal, toItem: addButtonP , attribute: .centerX, multiplier: 1, constant: 0)
        let activityCenterYConstraintr = NSLayoutConstraint(item: activityIndicatorP, attribute: .centerY, relatedBy: .equal, toItem: addButtonP , attribute: .centerY, multiplier: 1, constant: 0)
        
        let activityLabelTopConstraint = NSLayoutConstraint(item: activityLabelP , attribute: .top, relatedBy: .equal, toItem: activityIndicatorP, attribute: .bottom, multiplier: 1, constant: 20)
        let activityLabelCenterXConstraint = NSLayoutConstraint(item: activityLabelP, attribute: .centerX, relatedBy: .equal, toItem: addButtonP , attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addSubview(activityLabelP)
        self.view.addSubview(activityIndicatorP)
        self.view.addConstraints([activityCenterXConstraint, activityCenterYConstraintr, activityLabelTopConstraint, activityLabelCenterXConstraint])
        
        self.addButtonP.isHidden = true
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.activityIndicatorP.isHidden = false
        self.activityLabelP.isHidden = false
        self.activityIndicatorP.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.activityIndicatorP.stopAnimating()
            self.view.removeConstraints([activityCenterXConstraint, activityCenterYConstraintr, activityLabelTopConstraint, activityLabelCenterXConstraint])
            self.activityIndicatorP.removeFromSuperview()
            self.activityLabelP.removeFromSuperview()
            self.addButtonP.isHidden = false
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            completion()
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func canselButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
