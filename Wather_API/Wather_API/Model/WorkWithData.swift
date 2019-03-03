//
//  WorkWithData.swift
//  Wather_API
//
//  Created by Dmytro Ryshchuk on 3/2/19.
//  Copyright © 2019 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

enum Language: String {
    case ukrainian = "ua", english = "en", italian = "it", german = "de", spanish = "sp", french = "fr", swedish = "se"
}

enum Units {
    case metric, imperial
}

class WorkWithData {
    var response: Response?
    var forecast: Forecast?
    
    func getWeather(city: String, language: Language = .english, units: Units = .metric){
        let session = URLSession(configuration: .default)
        let url = "https://community-open-weather-map.p.rapidapi.com/weather?lang=\(language.rawValue)&units=\(units)&q=\(city)"
        let apiKey = "9b92450722msh86ab8b6cd4d0909p1e3a2ajsn1faebd87c4d4"
        let myURL = URL(string: url)
        var request =  URLRequest(url: myURL!)
        request.allHTTPHeaderFields = ["X-RapidAPI-Key": apiKey]
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            if error == nil {
                do {
                    let model = try JSONDecoder().decode(Response.self, from: data!)
                    self.fillResponse(data: model)
                } catch let err {
                    NotificationCenter.default.post(name: .didErrorHappened, object: nil)
                    print(err.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    func getForecastWeather(city: String, language: Language = .english, units: Units = .metric){
        let session = URLSession(configuration: .default)
        let url = "https://community-open-weather-map.p.rapidapi.com/forecast?lang=\(language.rawValue)&units=\(units)&q=\(city)"
        let apiKey = "9b92450722msh86ab8b6cd4d0909p1e3a2ajsn1faebd87c4d4"
        let myURL = URL(string: url)
        var request =  URLRequest(url: myURL!)
        request.allHTTPHeaderFields = ["X-RapidAPI-Key": apiKey]
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            if error == nil {
                do {
//                    let receivedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
//                                    print("\n\n", receivedData)
                    let model = try JSONDecoder().decode(Forecast.self, from: data!)
                    self.fillForecastResponse(data: model)
                } catch let err {
                    NotificationCenter.default.post(name: .didErrorHappened, object: nil)
                    print(err.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    private func fillResponse(data: Response?) {
        response = data
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
    }
    
    private func fillForecastResponse(data: Forecast?) {
        forecast = data
        print(forecast)
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
    }
}
