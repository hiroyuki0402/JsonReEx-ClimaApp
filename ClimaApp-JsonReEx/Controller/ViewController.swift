//
//  ViewController.swift
//  ClimaApp-JsonReEx
//
//  Created by SHIRAISHI HIROYUKI on 2022/05/03.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var countryLable: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var search: UIButton!

    private var locationManager: CLLocationManager!
    private var weatherManager: WeatherManager!
    private var weathers = [WeatherModel]()
    private var weathers2 = [AcquisitionTargetAtItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager = WeatherManager()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        print(weathers2)
        // 利用許可を促す
        locationManager.requestWhenInUseAuthorization()
        // 現在地の取得
        locationManager.requestLocation()
    }

    /// UIの更新
    private func updateUI() {
        guard let temperature = weathers.first?.temperatureString,
              let conditionName = weathers.first?.conditionNmae,
              let name = weathers.first?.cityName else { return }
        temperatureLabel.text = temperature
        weatherImageView.image = UIImage(systemName: conditionName)
        countryLable.text = name
    }


    @IBAction func searchPressed(_ sender: UIButton) {
        view.endEditing(true)
        // 現在地押下時
        if sender.tag == 1 {
            locationManager.requestLocation()
            // 検索ボタン押下時
        } else if sender.tag == 2 {
            // 地域検索
            guard let text = textField.text else { return }
            // async await
            Task {
                let url = weatherManager.fetchWeather(mode: .ctyName(text))
                let data =  try await weatherManager.performReqest(url: url)
                self.weathers =  data.compactMap {
                    WeatherModel(conditionId:  $0.weather[0].id, cityName: $0.name, temperature: $0.main.temp)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.updateUI()
                }
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let strigUrl = weatherManager.fetchWeather(mode: .location(lat: lat, lon: lon))
        Task {
            let data =  try await weatherManager.performReqest(url: strigUrl)
            self.weathers =  data.compactMap {
                WeatherModel(conditionId:  $0.weather[0].id, cityName: $0.name, temperature: $0.main.temp)
            }
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
