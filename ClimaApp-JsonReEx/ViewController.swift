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

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager = WeatherManager()
        locationManager = CLLocationManager()
        locationManager.delegate = self

        // 利用許可を促す
        locationManager.requestWhenInUseAuthorization()
        // 現在地の取得
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        view.endEditing(true)
        var strigUrl = ""

        if sender.tag == 1 {
            locationManager.requestLocation()
        } else if sender.tag == 2 {
            guard let text = textField.text else { return }
            strigUrl = weatherManager.fetchWeather(mode: .ctyName(text))
        }
        print(strigUrl)
        weatherManager.performReqest(url: strigUrl) { [weak self] result in
            switch result {
            case .success( let result):
                self?.weathers = result.compactMap {
                    WeatherModel(conditionId: $0.weather[0].id,
                                 cityName: $0.name,
                                 temperature: $0.main.temp)

                }
                DispatchQueue.main.async {
                    guard let temperature = self?.weathers[0].temperatureString,
                          let conditionNmae = self?.weathers[0].conditionNmae,
                          let name = self?.weathers[0].cityName else { return }
                    self?.temperatureLabel.text = temperature
                    self?.weatherImageView.image = UIImage(systemName: conditionNmae)
                    self?.countryLable.text = name
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let strigUrl = weatherManager.fetchWeather(mode: .location(lat: lat, lon: lon))

        weatherManager.performReqest(url: strigUrl) { [weak self] result in
            switch result {
            case .success( let result):
                self?.weathers = result.compactMap {
                    WeatherModel(conditionId: $0.weather[0].id,
                                 cityName: $0.name,
                                 temperature: $0.main.temp)
                }
                DispatchQueue.main.async {
                    guard let temperature = self?.weathers[0].temperatureString,
                          let conditionNmae = self?.weathers[0].conditionNmae,
                          let name = self?.weathers[0].cityName else { return }
                    self?.temperatureLabel.text = temperature
                    self?.weatherImageView.image = UIImage(systemName: conditionNmae)
                    self?.countryLable.text = name
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
