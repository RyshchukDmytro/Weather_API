//
//  ViewController.swift
//  Wather_API
//
//  Created by Dmytro Ryshchuk on 3/2/19.
//  Copyright © 2019 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    // MARK: - variables
    var workWithData = WorkWithData()
    var userLanguage: Language?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        self.userLanguage = Language.english
        workWithData.getWeather(city: "London", language: userLanguage!, units: .imperial)
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        updateView()
    }
    
    // MARK: - actions
    @IBAction func showCityForecast(_ sender: Any) {
        workWithData.getWeather(city: cityTextField.text!, language: userLanguage!, units: .metric)
    }
    
    @IBAction func chooseLanguage(_ sender: Any) {
        let alert = UIAlertController(title: "Languages", message: "Choose your language", preferredStyle: .actionSheet)
        
        let languages = [Language.english, Language.french, Language.german, Language.italian, Language.spanish, Language.swedish, Language.ukrainian]
        for language in languages {
            alert.addAction(UIAlertAction(title: language.rawValue, style: .default , handler:{ (UIAlertAction)in
                self.userLanguage = language
            }))
        }
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    // MARK: - functions
    func updateView() {
        if let response = workWithData.response {
            DispatchQueue.main.async {
                self.tempLabel.text = String(response.main.temp)
                self.descriptionLabel.text = response.weather.description
                self.windLabel.text = String(Int(response.wind.speed))
            }
        }
    }
    
    func alertEmptyCity() {
        let alert = UIAlertController(title: "Please fill city name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

