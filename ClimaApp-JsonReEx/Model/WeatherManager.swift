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

    func getUrl() -> URL? {
        switch self {
        case .ctyName(let string):
            let encodedString = String().encoderString(word: string) ?? ""
            return URL(string:  WeatherManager.Url.url + "&q=\(encodedString)")
        case .location(let lat, let lon):
            return URL(string: WeatherManager.Url.url + "&lat=\(lat)&lon=\(lon)")
        }
    }
}

enum ErrorType: Error {
    case testErr
}

private extension String {
    func encoderString(word: String) -> String? {
        let encodeString = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeString
    }
}

struct WeatherManager {
    struct Url {
        static let api = "appid=cbe1752976ad8c7fec68df0f03be2f35"
        static let internetProtocol = "https://"
        static let openweatherString = "api.openweathermap.org/data/2.5/weather?units=metric&"
        static let url = internetProtocol + openweatherString + api
    }
    /// 天気取得
    /// - Parameter url: TextFieldで入力した地域,国
    /// - Returns: AcquisitionTargetAtItemの配列(Codble)
    func performReqest(url: URL?) async throws -> [AcquisitionTargetAtItem] {
        guard let url = url else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let item = try JSONDecoder().decode(AcquisitionTargetAtItem.self, from: data)
        return [item]
    }
}



