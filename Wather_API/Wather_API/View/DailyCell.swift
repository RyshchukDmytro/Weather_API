//
//  DailyCell.swift
//  Wather_API
//
//  Created by Dmytro Ryshchuk on 3/5/19.
//  Copyright © 2019 Dmytro Ryshchuk. All rights reserved.
//

import UIKit

class DailyCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempAtDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(list: List) {
        showDayOfWeek(list: list)
        downloadIcon(list: list)
        tempAtDayLabel.text = String(Int(list.main.temp)) + "°"
    }
    
    private func showDayOfWeek(list: List) {
        let dateArray = list.dtTxt.split(separator: " ")
        let stringDate = "\(dateArray[0])T\(dateArray[1])+0000"
        let dateFormatterISO = ISO8601DateFormatter()
        let date = dateFormatterISO.date(from:stringDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDateString: String = dateFormatter.string(from: date)
        dayLabel.text = currentDateString
    }
    
    private func downloadIcon(list: List) {
        let icon = list.weather[0].icon
        let serialQueue = DispatchQueue(label: "queuename")
        serialQueue.sync {
            let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                iconImage.image = image
            }
        }
    }
}
