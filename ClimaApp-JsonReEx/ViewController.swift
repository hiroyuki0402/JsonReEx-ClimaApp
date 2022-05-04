//
//  ViewController.swift
//  ClimaApp-JsonReEx
//
//  Created by SHIRAISHI HIROYUKI on 2022/05/03.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var countryLable: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    private var weatherManager: WeatherManager!
    private var weathers = [WeatherModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager = WeatherManager()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        guard let text = textField.text else { return }
        let strigUrl = weatherManager.fetchWeather(ctyName: text)
        weatherManager.performReqest(url: strigUrl) { [weak self] result in
            switch result {
            case .success( let result):
                self?.weathers = result.compactMap {
                    WeatherModel(conditionId: $0.weather[0].id,
                                 cityName: $0.name,
                                 temperature: $0.main.temp)
                }
                DispatchQueue.main.async {
                    guard let conditionId = self?.weathers[0].conditionId, let temperature = self?.weathers[0].temperatureString  else { return }

                    print(temperature)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
}
