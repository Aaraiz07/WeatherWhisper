//
//  WeatherData.swift
//  WeatherWhisper
//
//  Created by Aaraiz Wasim on 19/10/2023.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
