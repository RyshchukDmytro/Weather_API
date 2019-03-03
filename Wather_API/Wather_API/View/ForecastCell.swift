//
//  ForecastCell.swift
//  Wather_API
//
//  Created by Dmytro Ryshchuk on 3/3/19.
//  Copyright © 2019 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconWeatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func setUp(list: List) {
        let time = list.dtTxt.suffix(9).prefix(3).dropFirst()
        timeLabel.text = String(time)
        temperatureLabel.text = String(Int(list.main.temp)) + "°"
        let icon = list.weather[0].icon
        let serialQueue = DispatchQueue(label: "queuename")
        serialQueue.sync {
            let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                iconWeatherImage.image = image
            }
        }
    }
}
