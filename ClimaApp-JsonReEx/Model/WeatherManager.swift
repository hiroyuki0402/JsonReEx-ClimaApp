//
//  WeatherManager.swift
//  ClimaApp-JsonReEx
//
//  Created by SHIRAISHI HIROYUKI on 2022/05/03.
//

import Foundation
import CoreLocation
import UserNotifications

enum URLMode {
    case ctyName(String)
    case location(lat: CLLocationDegrees, lon: CLLocationDegrees)
}

enum ErrorType: Error {
    case testErr
}

struct WeatherManager {

    struct Url {
        static let api = "appid=cbe1752976ad8c7fec68df0f03be2f35"
        static let internetProtocol = "https://"
        static let openweatherString = "api.openweathermap.org/data/2.5/weather?units=metric&"
        static let url = internetProtocol + openweatherString + api
    }
    var weatherUrl = Url.url
    /// URLのモードの判定
    /// - Parameter mode: URLMode
    /// - Returns: modeのURLの文字列
    func fetchWeather(mode: URLMode) -> String {
        var url: String
        // モードの判定
        switch mode {
            // 地域名
        case .ctyName(let string):
            url = "\(weatherUrl)&q=\(string)"
            // 現在地
        case .location(let lat, let lon):
            url = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        }
        return url
    }
    /// 天気取得
    /// - Parameter url: URL
    /// - Returns: ハンドラー
    func performReqest(url: String) async -> Result<[AcquisitionTargetAtItem], Error> {
        guard let url = URL(string: url) else {
            return  .failure(ErrorType.testErr)
        }
        // async await
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode(AcquisitionTargetAtItem.self, from: data)
            print(item)
            return .success([item])
        } catch {
            return  .failure(ErrorType.testErr)
        }
    }
}



