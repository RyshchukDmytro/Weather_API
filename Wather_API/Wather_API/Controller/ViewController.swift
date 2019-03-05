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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    
    // MARK: - variables
    private var workWithData = WorkWithData()
    private var userLanguage: Language?
    private var userUnit: Units?
    private var city = "Kyiv"
    private var forecastDaily: [List]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidErrorHappened(_:)), name: .didErrorHappened, object: nil)
        self.activityIndicatorView.hidesWhenStopped = true
        self.userLanguage = Language.english
        self.userUnit = Units.metric
        forecastDaily = []
        startSearching()
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        DispatchQueue.main.async {
            self.updateView()
            self.forecastCollectionView.reloadData()
            self.dailyTableView.reloadData()
        }
    }
    
    @objc func onDidErrorHappened(_ notification:Notification) {
        alertEmptyCity(text: "Unexpected Error")
    }
    
    @IBAction func openSettings(_ sender: Any) {
        alertInSetting()
    }
    
    // MARK: - functions
    private func updateView() {
        if let response = workWithData.response {
            self.activityIndicator(show: false)
            let unit = self.userUnit == Units.metric ? "m/s" : "mph"
            let icon = response.weather[0].icon
            var side = ""
            if let deg = response.wind.deg {
                side = self.windBlow(degree: deg) + " "
            }
            self.cityLabel.text = response.name
            self.tempLabel.text = String(Int(response.main.temp)) + "°"
            self.descriptionLabel.text = response.weather[0].description
            self.windLabel.text = "\(side)\(response.wind.speed) \(unit)"
            self.cloudsLabel.text = String(response.clouds.all) + "%"
            self.humidityLabel.text = String(response.main.humidity) + "%"
            self.pressureLabel.text = String(response.main.pressure) + " hPa"
            self.sunriseLabel.text = self.timestampToString(time: Double(response.sys.sunrise))
            self.sunsetLabel.text = self.timestampToString(time: Double(response.sys.sunset))

            let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")
            let data = try? Data(contentsOf: url!)
            let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
            concurrentQueue.sync {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.weatherIcon.image = image
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
    
    private func activityIndicator(show: Bool) {
        if show {
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    private func startSearching() {
        self.workWithData.getWeather(api: .forecast, city: city)
        self.activityIndicator(show: true)
        self.workWithData.getWeather(api: .weather, city: city, language: userLanguage!, units: userUnit!)
    }
    
    private func windBlow(degree: Double) -> String {
        let sides = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                     "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]
        let position = Int(degree / 22.5) + 1
        return sides[position]
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
        self.present(alert, animated: true)
    }
    
    private func changeCityInAlert() {
        let alert = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "City"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let city = alert.textFields?.first?.text {
                let cityWithoutEmptySpace = city.replacingOccurrences(of: " ", with: "+")
                self.city = cityWithoutEmptySpace
                self.startSearching()
            }
        }))
        self.present(alert, animated: true)
    }
    
    private func languagesInAlert() {
        let alert = UIAlertController(title: "Languages", message: "Choose your language", preferredStyle: .actionSheet)
        
        let languages = [Language.english, Language.french, Language.german, Language.italian, Language.spanish, Language.swedish, Language.ukrainian]
        for language in languages {
            alert.addAction(UIAlertAction(title: language.rawValue, style: .default , handler:{ (UIAlertAction)in
                self.userLanguage = language
                self.startSearching()
            }))
        }
        self.present(alert, animated: true)
    }
    
    private func metricTypeInAlert() {
        let alert = UIAlertController(title: "Units", message: "Choose your system", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Metric", style: .default, handler:{ (UIAlertAction) in
            self.userUnit = Units.metric
            self.startSearching()
        }))
        alert.addAction(UIAlertAction(title: "Imperial", style: .default, handler:{ (UIAlertAction) in
            self.userUnit = Units.imperial
            self.startSearching()
        }))
        self.present(alert, animated: true)
    }
    
    private func alertEmptyCity(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            self.activityIndicator(show: false)
        }))
        self.present(alert, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let forecast = workWithData.forecast {
            return forecast.list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! ForecastCell
        if let forecast = workWithData.forecast {
            cell.setUp(list: forecast.list[indexPath.row])
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastDaily = []
        if let list = workWithData.forecast?.list {
            for i in 0..<list.count {
                let time = list[i].dtTxt.suffix(9).prefix(3).dropFirst()
                if String(time) == "15" {
                    self.forecastDaily?.append(list[i])
                }
            }
        }
        return forecastDaily?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyCell
        if let list = forecastDaily {
            cell.setUp(list: list[indexPath.row])
        }
        return cell
    }
}
