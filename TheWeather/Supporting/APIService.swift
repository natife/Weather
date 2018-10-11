
import Foundation
import Alamofire

enum WeatherBaseLink: String{
    case current = "https://api.openweathermap.org/data/2.5/weather"
    case forecast = "https://api.openweathermap.org/data/2.5/forecast"
    case currentByCity = "https://api.openweathermap.org/data/2.5/weather?q="
    case forecastByCity = "https://api.openweathermap.org/data/2.5/forecast?q="
}

enum WeatherRequest: Int{
    case coords, cityName
}

class APIService{
    
    func reusableRequest<T:Decodable>(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping (T?) -> Void){
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                do{
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .customISO8601
                    let result = try decoder.decode(T.self, from: response.data!)
                    completion(result)
                }catch let error{
                    print(error)
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getForecast(by: WeatherRequest, fromLat latitude: Double?, andLong longitude: Double?, cityName: String?, completion: @escaping (WeatherModel?) -> Void){
        var url = ""
        let baseLink: WeatherBaseLink
        switch by{
        case .coords:
            baseLink = .forecast
        case .cityName:
            baseLink = .forecastByCity
        }
        
        if let lat = latitude, let long = longitude, long != 0.0, lat != 0.0{
            url = "\(baseLink.rawValue)?lat=\(String(lat))&lon=\(String(long))&appid=0299b07f2f5c599fae9c005e0df77b3a"
        }else if let cityName = cityName{
            url = baseLink.rawValue + cityName + "&appid=0299b07f2f5c599fae9c005e0df77b3a"
        }
        
        reusableRequest(url, method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: nil, completion: completion)
    }
    
    func getWeather(by: WeatherRequest, fromLat latitude: Double?, andLong longitude: Double?, cityName: String?, completion: @escaping (WeatherCurrentModel?) -> Void){
        var url = ""
        let baseLink: WeatherBaseLink
        switch by{
        case .coords:
            baseLink = .current
        case .cityName:
            baseLink = .currentByCity
        }
        
        if latitude! != 0.0, longitude! != 0.0{
            url = "\(baseLink.rawValue)?lat=\(String(latitude!))&lon=\(String(longitude!))&appid=0299b07f2f5c599fae9c005e0df77b3a"
        }else if let cityName = cityName{
            url = baseLink.rawValue + cityName + "&appid=0299b07f2f5c599fae9c005e0df77b3a"
        }
        
        reusableRequest(url, method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: nil, completion: completion)
    }
    
    func getSearchResult(forRequest request: String, completion: @escaping (SearchModel?) -> Void){
        reusableRequest("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(request)&types=geocode&key=AIzaSyALLSV2e6wObyfP992HZzyDNanY1Pi-KXw", method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: nil, completion: completion)
    }
    
}
