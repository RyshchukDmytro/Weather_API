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
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // MARK: - variables
    var workWithData = WorkWithData()
    var userLanguage: Language?
    var userUnit: Units?
    var city = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        self.userLanguage = Language.english
        self.userUnit = Units.metric
        workWithData.getWeather(city: "London", language: userLanguage!, units: userUnit!)
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        updateView()
    }
    
    @objc func onDidErrorHappened(_ notification:Notification) {
        alertEmptyCity(text: "Unexpected Error")
    }
    
    @IBAction func openSettings(_ sender: Any) {
        alertInSetting()
    }
    
    // MARK: - functions
    func updateView() {
        if let response = workWithData.response {
            DispatchQueue.main.async {
                let speed = self.userUnit == Units.metric ? "kmh" : "mph"
                let icon = response.weather[0].icon
                self.cityLabel.text = response.name
                self.tempLabel.text = String(Int(response.main.temp)) + "°"
                self.descriptionLabel.text = response.weather[0].description
                self.windLabel.text = String(response.wind.speed) + " \(speed)"
                self.cloudsLabel.text = String(response.clouds.all) + "%"
                self.humidityLabel.text = String(response.main.humidity) + "%"
                self.pressureLabel.text = String(response.main.pressure) + " hPa"
                self.sunriseLabel.text = self.timestampToString(time: Double(response.sys.sunrise))
                self.sunsetLabel.text = self.timestampToString(time: Double(response.sys.sunset))

                let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.weatherIcon.image = image
                    }
                }
            }
        }
    }
    
    private func timestampToString(time: Double) -> String {
        let dateSunrise = NSDate(timeIntervalSince1970: time)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "HH:mm"
        return dayTimePeriodFormatter.string(from: dateSunrise as Date)
    }
}

extension ViewController {
    private func alertInSetting() {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Change city", style: .default, handler:{ (UIAlertAction) in
            self.changeCityInAlert()
        }))
        alert.addAction(UIAlertAction(title: "Language", style: .default, handler:{ (UIAlertAction) in
            self.languagesInAlert()
        }))
        alert.addAction(UIAlertAction(title: "Unit", style: .default, handler:{ (UIAlertAction) in
            self.metricTypeInAlert()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler:{ (UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func changeCityInAlert() {
        let alert = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "City"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let city = alert.textFields?.first?.text {
                self.city = city
                self.workWithData.getWeather(city: city, language: self.userLanguage!, units: self.userUnit!)
            }
        }))
        
        self.present(alert, animated: true)    }
    
    private func languagesInAlert() {
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
    
    private func metricTypeInAlert() {
        let alert = UIAlertController(title: "Units", message: "Choose your system", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Metric", style: .default , handler:{ (UIAlertAction)in
            self.userUnit = Units.metric
        }))
        alert.addAction(UIAlertAction(title: "Imperial", style: .default , handler:{ (UIAlertAction)in
            self.userUnit = Units.imperial
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func alertEmptyCity(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
