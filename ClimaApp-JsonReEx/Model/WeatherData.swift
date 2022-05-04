//
//  WeatherData.swift
//  ClimaApp-JsonReEx
//
//  Created by SHIRAISHI HIROYUKI on 2022/05/04.
//

import Foundation

struct AcquisitionTargetAtItem: Codable {
    let name: String
    let weather: [AcquisitionTargetAtWeatherItem]
    let main: AcquisitionTargetAtMainItem
}

struct AcquisitionTargetAtWeatherItem: Codable {
    var id: Int
    var description: String
}

struct AcquisitionTargetAtMainItem: Codable {
    let temp: Float
}


 // MARK: ALL Data

struct AllItems: Codable {
    let coord: AllCoord
    let weather: [AllWeatherItem]
    let base: String
    let main: AllMain
    let visibility: Int
    let wind: AllWind
    let clouds: AllClouds
    let dt: Int
    let sys: AllSys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct AllItem: Codable {
    let coord: AllCoord
    let weather: AllWeatherItem
    let base: String
    let main: AllMain
    let visibility: Int
    let wind: AllWind
    let clouds: AllClouds
    let dt: Int
    let sys: AllSys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct AllCoord: Codable {
    let lon: Double
    let lat: Double
}

struct AllWeatherItem: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct AllMain: Codable {
    let temp: Float
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct AllWind: Codable {
    let speed: Double
    let deg: Int
}
struct AllClouds: Codable {
    let all: Int
}
struct AllSys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
