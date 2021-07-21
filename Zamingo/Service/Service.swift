//
//  Service.swift
//  Zamingo
//
//  Created by Roi Kedarya on 20/07/2021.
//

import Foundation

enum ServiceError: Error {
    case badResponse
    case parsingFailed
    case invalidUrl
    case fileNotFound
}

class Service {
    
    static let shared = Service()
    private var sportsUrl: URL?
    private var cultureUrl: URL?
    private var carsUrl: URL?
    
    private init () {
        
    }
    
    private func getUrl(for fileName: ChannelType) -> URL? {
        if let urlPathString = Bundle.main.path(forResource: fileName.rawValue, ofType: "json") {
            return URL(fileURLWithPath: urlPathString)
        } else {
            print("Cant Find file in Destination for \(fileName).json")
            return nil
        }
    }
    
    private func getItems(for url: URL, completion: @escaping ([Item]?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("updating")
            if let error = error {
                completion(nil,error)
                return
            }
            if let data = data {
                if let items =  try? JSONDecoder().decode([Item].self, from: data) {
                    completion(items,nil)
                }else {
                    completion(nil,ServiceError.parsingFailed)
                }
            }
        }.resume()
    }
    
    func getItems(for type: ChannelType, completion: @escaping ([Item]?, Error?) -> ()) {
        if let url = getUrl(for: type) {
            getItems(for: url) { items, error in
                if let error = error {
                    completion(nil,error)
                } else if let items = items {
                    //parse the items
                    completion(items,nil)
                }
            }
        }
    }
}
