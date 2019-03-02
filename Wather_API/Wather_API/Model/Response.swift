//
//  Response.swift
//  Wather_API
//
//  Created by Dmytro Ryshchuk on 3/2/19.
//  Copyright © 2019 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

struct Response {
    let name, base: String
    let id, visibility, dt, cod: Int
    let code: Clouds
    let sys: Sys
    let wind: Wind
    let main: Main
    let coord: Coord
    let weather: Weather
}

struct Clouds {
    let all: Int
}

struct Sys {
    let country: String
    let message: NSNumber
    let id, sunrise, sunset, type: Int
}

struct Wind {
    let deg, speed: NSNumber
}

struct Main {
    let humidity, pressure: Int
    let temp, temp_max, temp_min: Double
}

struct Coord {
    let lat, lon: Double
}

struct Weather {
    let description, icon, main: String
    let id: Int
}
