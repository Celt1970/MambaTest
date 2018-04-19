//
//  AddCityViewController.swift
//  MambaTest
//
//  Created by demo on 19.04.2018.
//  Copyright © 2018 demo. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityPopulationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let previousVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! CitiesViewConrtoller
//        let city = City(name: "Novgorod", people: 2345678)
        previousVC.viewModel.addCity(cityNameTextField.text ?? "", withPeople: cityPopulationTextField.text ?? "0")
        self.navigationController?.popToViewController(previousVC, animated: true)
    }
    func customiseNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        let leftBarButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(canselButtonPressed))
        
        
        self.navigationItem.setLeftBarButton(leftBarButton, animated: false)
        self.navigationItem.title = "Новый город"
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    @objc func canselButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
