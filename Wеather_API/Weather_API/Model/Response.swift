//
//  Response.swift
//  Wather_API
//
//  Created by Dmytro Ryshchuk on 3/2/19.
//  Copyright © 2019 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

struct OneDayResponse: Codable {
    let base, name: String
    let cod, dt, id: Int
    let visibility: Int?
    let clouds: Clouds
    let coord: Coord
    let main: Main
    let sys: Sys
    let wind: Wind
    let weather: [Weather]
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lat, lon: Double
}

struct Main: Codable {
    let humidity: Int
    let temp, pressure, tempMax, tempMin: Double
    
    enum CodingKeys: String, CodingKey {
        case humidity, pressure, temp
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}

struct Sys: Codable {
    let country: String
    let id, type: Int?
    let message: Double
    let sunrise, sunset: Int
}

struct Wind: Codable {
    let deg: Double?
    let speed: Double
    let gust: Double?
}

struct Weather: Codable {
    let description, icon: String
    let id: Int
    let main: String
}

struct ForecastResponse: Codable {
    let city: City
    let cod: String?
    let message: Double
    let cnt: Int
    let list: [List]
}

struct City: Codable {
    let country: String
    let id: Int
    let name: String
    let population: Int?
    let coord: Coord
}

struct List: Codable {
    let dt: Int
    let dtTxt: String
    let clouds: Clouds
    let main: Main
    let sys: SysList
    let weather: [Weather]
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case clouds, dt
        case dtTxt = "dt_txt"
        case main, sys, weather, wind
    }
}

struct SysList: Codable {
    let pod: String
}
