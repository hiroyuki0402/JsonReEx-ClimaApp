//
//  WeatherModel.swift
//  ClimaApp-JsonReEx
//
//  Created by SHIRAISHI HIROYUKI on 2022/05/04.
//

import Foundation


struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Float

    var temperatureString: String {
        String(format: "%.1f", temperature)
    }

    var conditionNmae: String {
        switch conditionId {
            // 雷雨
        case 200...232:
            return "cloud.bolt"
            // 霧雨
        case 300...321:
            return "cloud.drizzle"
            // 雨
        case 500...531:
            return "cloud.rain"
            // 雪
        case 600...622:
            return "cloud.snow"
            // 大気
        case 701...781:
            return "cloud.fog"
            // 晴天
        case 800:
            return "sun.max"
            // 曇り(雲量)
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
