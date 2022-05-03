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

    func performReqest(url: String, complision: @escaping(Result<[WeatherItem], Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let reqestUrl = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: reqestUrl) { data, _, err in
            if let err = err {
                print(err)
                complision(.failure(err))
            } else if let data = data {
                do {
                let responseData = try JSONDecoder().decode(Items.self, from: data)
                    print(responseData)
//                    complision( .success(responseData.name) )

                } catch let err {
                    complision(.failure(err))
                }
            }
        }
        task.resume()

    }
}

struct Items: Codable {
    let coord: Coord
    let weather: [WeatherItem]
    let base: String
    let main: Main
    let visibility: Int
//    let wind:
//    let clouds:
    let dt: Int
//    let sys:
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int

}


struct WeatherItem: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

//let Item {
//    let coord: String
//    let weather:
//
//}
struct WeatherItems: Codable {
    let weather: [WeatherItem]
}
//struct WeatherItems: Codable {
//    let weather: [WeatherItem]
//}

//"coord": {},
//"weather": [],
//"base": "stations",
//"main": {},
//"visibility": 10000,
//"wind": {},
//"clouds": {},
//"dt": 1651587465,
//"sys": {},
//"timezone": 32400,
//"id": 1850147,
//"name": "Tokyo",
//"cod": 200
//}

//{
//"coord": {
//"lon": 139.6917,
//"lat": 35.6895
//},
//"weather": [
//{
//"id": 800,
//"main": "Clear",
//"description": "clear sky",
//"icon": "01n"
//}
//],
//"base": "stations",
//"main": {
//"temp": 15.46,
//"feels_like": 14.78,
//"temp_min": 12.08,
//"temp_max": 17.53,
//"pressure": 1019,
//"humidity": 66
//},
//"visibility": 10000,
//"wind": {
//"speed": 4.63,
//"deg": 190
//},
//"clouds": {
//"all": 0
//},
//"dt": 1651587465,
//"sys": {
//"type": 2,
//"id": 2038398,
//"country": "JP",
//"sunrise": 1651520859,
//"sunset": 1651570112
//},
//"timezone": 32400,
//"id": 1850147,
//"name": "Tokyo",
//"cod": 200
//}
