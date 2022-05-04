//
//  WeatherManager.swift
//  ClimaApp-JsonReEx
//
//  Created by SHIRAISHI HIROYUKI on 2022/05/03.
//

import Foundation


struct WeatherManager {
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=cbe1752976ad8c7fec68df0f03be2f35"

    func fetchWeather(ctyName: String) -> String {
        let urlStrig = "\(weatherUrl)&q=\(ctyName)"
        return urlStrig
    }

    func performReqest(url: String, complision: @escaping(Result<[AcquisitionTargetAtItem], Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let reqestUrl = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: reqestUrl) { data, _, err in
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



