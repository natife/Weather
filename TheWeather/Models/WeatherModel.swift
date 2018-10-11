
import Foundation

struct WeatherModel: Codable {
    let cod: String
    let list: [List]
    let city: City
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
}

struct Coord: Codable {
    let lat, lon: Double
}

struct List: Codable {
    let dt: Int
    var main: Main
    var weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let dt_txt: Date
}

struct Clouds: Codable {
    let all: Int
}

struct Main: Codable {
    var temp, temp_min, temp_max, pressure: Double
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    var icon: String
}

struct Wind: Codable {
    let speed, deg: Double
}

struct WeatherCurrentModel: Codable{
    let id: Int
    let name: String
    let cod: Int
    let coord: Coord
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let main: Main
    let dt: Int
}
