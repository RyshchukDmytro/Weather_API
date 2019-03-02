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
    
    func getWeather(city: String, language: Language = .english, units: Units = .metric){
        let session = URLSession(configuration: .default)
        //        var datatask : URLSessionDataTask?
        let url = "https://community-open-weather-map.p.rapidapi.com/weather?lang=\(language.rawValue)&units=\(units)&q=\(city)"
        let apiKey = "9b92450722msh86ab8b6cd4d0909p1e3a2ajsn1faebd87c4d4"
        let myURL = URL(string: url)
        var request =  URLRequest(url: myURL!)
        request.allHTTPHeaderFields = ["X-RapidAPI-Key": apiKey]
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            if error == nil {
                let receivedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                //                print(receivedData)
                let data = receivedData!
                self.fillResponse(data: data)
            }
        })
        task.resume()
    }
    
    func fillResponse(data: [String: Any]?) {
        let name = data?["name"] as! String
        let clouds = data?["clouds"] as? [String: Any]
        let cloudsAll = clouds?["all"] as! Int
        let id = data?["id"] as! Int
        let base = data?["base"] as! String
        let sys = data?["sys"] as? [String: Any]
        let sysCountry = sys?["country"] as! String
        let sysId = sys?["id"] as! Int
        let sysMessage = sys?["message"] as! NSNumber
        let sysSunrise = sys?["sunrise"] as! Int
        let sysSunset = sys?["sunset"] as! Int
        let sysType = sys?["type"] as! Int
        let visibility = data?["visibility"] as! Int
        let dt = data?["dt"] as! Int
        let wind = data?["wind"] as? [String: Any]
        let windDeg = wind?["deg"] as! NSNumber
        let windSpeed = wind?["speed"] as! NSNumber
        let cod = data?["cod"] as! Int
        let main = data?["main"] as? [String: Any]
        let mainHumidity = main?["humidity"] as! Int
        let mainPressure = main?["pressure"] as! Int
        let mainTemp = main?["temp"] as! Double
        let mainTemp_max = main?["temp_max"] as! Double
        let mainTemp_min = main?["temp_min"] as! Double
        let coord = data?["coord"] as? [String: Any]
        let coordLat = coord?["lat"] as! Double
        let coordLon = coord?["lon"] as! Double
        let weather = data?["weather"] as? [[String: Any]]
        let weatherDescription = weather?[0]["description"] as! String
        let weatherIcon = weather?[0]["icon"] as! String
        let weatherId = weather?[0]["id"] as! Int
        let weatherMain = weather?[0]["main"] as! String
        
        response = Response(name: name, base: base, id: id,
                            visibility: visibility, dt: dt, cod: cod,
                            code:Clouds(all: cloudsAll),
                            sys: Sys(country: sysCountry, message: sysMessage, id: sysId, sunrise: sysSunrise, sunset: sysSunset, type: sysType),
                            wind: Wind(deg: windDeg, speed: windSpeed),
                            main: Main(humidity: mainHumidity, pressure: mainPressure, temp: mainTemp, temp_max: mainTemp_max, temp_min: mainTemp_min),
                            coord: Coord(lat: coordLat, lon: coordLon),
                            weather: Weather(description: weatherDescription, icon: weatherIcon, main: weatherMain, id: weatherId))
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
    }
}