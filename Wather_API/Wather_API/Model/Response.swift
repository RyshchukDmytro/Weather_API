//
//  Response.swift
//  Wather_API
//
//  Created by Dmytro Ryshchuk on 3/2/19.
//  Copyright © 2019 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

struct Response: Codable {
    let cod: Int
    let main: Main
    let sys: Sys
    let base: String
    let clouds: Clouds
    let wind: Wind
    let name: String
    let coord: Coord
    let dt, id: Int
    let visibility: Int?
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
