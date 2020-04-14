//
//  RemoteDataService.swift
//  YAWA-Demo
//
//  Created by Bink Wang on 8/12/18.
//  Copyright © 2018 Bink Wang. All rights reserved.
//

import Foundation

class RemoteDataService {
    
    static let shared = RemoteDataService()
    
    private init() {}
    
    private enum Endpoint {
        static let Weather: String = "http://api.openweathermap.org/data/2.5/forecast/daily?"
        static let WeatherIcon: String = "http://openweathermap.org/img/w/"
    }
    
    func fetchWeathers(cityName: String?, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        
        guard let cityName = cityName, !(cityName.isEmpty) else { return }
        
        // url. An example: http://api.openweathermap.org/data/2.5/forecast/daily?q=London&mode=json&units=metric&cnt=7&appid=542ffd081e67f4512b705f89d2a611b2
        let url = "\(String(describing: Endpoint.Weather))q=\(String(describing: cityName))&mode=json&units=metric&cnt=7&appid=\(OWMAPIKey)"
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            completion(data, response, error)
        })
        dataTask.resume()
    }
    
    func getWeatherImage(code: String?, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        guard let code = code, !(code.isEmpty) else { return }
        
        // url. An example: http://openweathermap.org/img/w/10d.png
        let url = "\(String(describing: Endpoint.WeatherIcon))\(String(describing: code)).png"
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { (data, response, error) -> Void in
            completion(data, response, error)
        }.resume()
    }
    
}