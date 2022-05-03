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

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager = WeatherManager()
        // Do any additional setup after loading the view.
    }
    @IBAction func searchPressed(_ sender: Any) {
        guard let text = textField.text else { return }
        let strigUrl = weatherManager.fetchWeather(ctyName: text)
        weatherManager.performReqest(url: strigUrl) { result in
            switch result {
            case .success( let result):
                result.compactMap {
                    print($0.main)
                }
            case .failure(let err):
                print(err)
            }
        }

    }


}

extension ViewController: UITextFieldDelegate {
    
}
