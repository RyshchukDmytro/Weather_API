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

enum Units: String {
    case metric = "metric", imperial = "imperial"
}

enum Api {
    case weather, forecast
}

class WorkWithData {
    var response: OneDayResponse?
    var forecast: ForecastResponse?
    
    func getWeather(api: Api, city: String, language: Language = .english, units: Units = .metric){
        let session = URLSession(configuration: .default)
        let baseUrl = "https://community-open-weather-map.p.rapidapi.com/\(api)"
        let url = createQuery(baseUrl: baseUrl, city: city, language: language, units: units)
        let apiKey = "9b92450722msh86ab8b6cd4d0909p1e3a2ajsn1faebd87c4d4"
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-RapidAPI-Key": apiKey]
        let task = session.dataTask(with: request, completionHandler: {data, resp, error in
            if error == nil {
//                let receivedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
//                print(receivedData)
                do {
                    if api == .weather {
                        let model = try JSONDecoder().decode(OneDayResponse.self, from: data!)
                        self.response = model
                        NotificationCenter.default.post(name: .didReceiveData, object: nil)
                    } else {
                        let model = try JSONDecoder().decode(ForecastResponse.self, from: data!)
                        self.forecast = model
                        NotificationCenter.default.post(name: .didReceiveData, object: nil)
                    }
                } catch let err {
                    NotificationCenter.default.post(name: .didErrorHappened, object: nil)
                    print(err.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    private func createQuery(baseUrl: String, city: String, language: Language, units: Units) -> URL {
        let cityWithoutEmptySpaces = city.replacingOccurrences(of: " ", with: "+")
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "lang", value: language.rawValue))
        queryParameters.append(URLQueryItem(name: "units", value: units.rawValue))
        queryParameters.append(URLQueryItem(name: "q", value: cityWithoutEmptySpaces))
        var query = URLComponents(url: URL.init(string: baseUrl)!, resolvingAgainstBaseURL: true)
        query?.queryItems = queryParameters
        return  (query?.url)!
    }
}
