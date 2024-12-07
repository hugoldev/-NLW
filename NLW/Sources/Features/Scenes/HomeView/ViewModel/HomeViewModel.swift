//
//  HomeViewModel.swift
//  NLW
//
//  Created by Hugo Lopes on 15/12/24.
//


import Foundation
import CoreLocation

class HomeViewModel {
    private let baseURL = "http:1270.0.0.1:3333"
    var userLatitude = -23.561187293883442
    var usarLongitude = -46.6564551388116494
    var places: [Place] = []
    var categories: [Category] = []
    var filteredPlaces: [Place] = []
    
    
    var didUpdateCategories: (([Category]) -> Void)?
    var didUpdatePlaces: (([Place]) -> Void)?
    
     func fetchInitialData(completion: @escaping ([Category]) -> Void) {
        fetchCategories { categories in
            completion(categories)
            if let fooCategory = categories.first(where: {$0.name == "Alimentação"}) {
                self.fetchPlaces(for: fooCategory.id, userLocation: CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.usarLongitude))
            }
        }
    }
        
    
     func fetchCategories(completion: @escaping ([Category]) -> Void) {
        guard let url = URL(string: "\(baseURL)/categories") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching categories: \(error)")
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let categories = try JSONDecoder().decode([Category].self, from: data)
                DispatchQueue.main.async {
                    completion(categories)
                }
            } catch {
                print("Error decoding categories: \(error)")
                completion([])
            }
            
        }.resume()
    }
    
     func fetchPlaces(for categoryID: String, userLocation: CLLocationCoordinate2D) {
        guard let url = URL(string: "\(baseURL)/markets/\(categoryID)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching categories: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                self.places  = try JSONDecoder().decode([Place].self, from: data)
                DispatchQueue.main.async {
                    self.didUpdatePlaces?(self.places)
                }
            } catch {
                print("Error decoding categories: \(error)")
            }
        }.resume()
    }
}
