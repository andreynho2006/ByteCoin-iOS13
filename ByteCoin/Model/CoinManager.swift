//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "FFCB0C60-DEE5-4785-8F1E-22E8A213325C"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        
        // use string concatenation to add the selected currency at the end of the base url along with the API key
        let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        
        // use optional binding to unwrap the URL that;s created from the urlString
        if let url = URL(string: urlString) {
            
            // create a new URLSession object with default configuration
            let session = URLSession(configuration: .default)
            
            // create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        // call the delegate method in the delegate (ViewController) and pass along the necesarry data
                        delegate?.didUpdatePrice(price: priceString, currency: currency)
                     }
                }
               
            }
            // start task to fetch data from bitcoin average's servers
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        // create a JSON decoder
        let decoder = JSONDecoder()
        
        do {
            // try to decode the data using a CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            // get the last property from the decoded data
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
