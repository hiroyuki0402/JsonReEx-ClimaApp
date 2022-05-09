//
//  WeatherManager.swift
//  ClimaApp-JsonReEx
//
//  Created by SHIRAISHI HIROYUKI on 2022/05/03.
//

import Foundation
import CoreLocation

enum URLMode {
    case ctyName(String)
    case location(lat: CLLocationDegrees, lon: CLLocationDegrees)
}

struct WeatherManager {

    struct Url {
        static let api = "appid=cbe1752976ad8c7fec68df0f03be2f35"
        static let internetProtocol = "https://"
        static let openweatherString = "api.openweathermap.org/data/2.5/weather?units=metric&"
        static let url = internetProtocol + openweatherString + api
    }
    var weatherUrl = Url.url

    func fetchWeather(mode: URLMode) -> String {
        var url: String

        switch mode {
        case .ctyName(let string):
            url = "\(weatherUrl)&q=\(string)"
        case .location(let lat, let lon):
            url = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        }
        return url
    }

    func performReqest(url: String, complision: @escaping(Result<[AcquisitionTargetAtItem], Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let reqestUrl = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: reqestUrl) { data, _, err in
            if let err = err {
                complision(.failure(err))
            } else if let data = data {

                do {
                let responseData = try JSONDecoder().decode(AcquisitionTargetAtItem.self, from: data)
                    let id = responseData.weather[0].id
                    let description = responseData.weather[0].description
                    let temp = responseData.main.temp
                    let name = responseData.name
                    let acquisitionTargetAtWeather: AcquisitionTargetAtWeatherItem = .init(id: id, description: description)
                    let acquisitionTargetAtMainItem: AcquisitionTargetAtMainItem = .init(temp: temp)

                    let data: AcquisitionTargetAtItem = .init(name: name, weather: [acquisitionTargetAtWeather], main: acquisitionTargetAtMainItem)
                    complision(.success([data]))
                } catch let err {
                    complision(.failure(err))
                }
            }
        }
        task.resume()
    }
}



