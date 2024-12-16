//
//  PlaceModel.swift
//  NLW
//
//  Created by Hugo Lopes on 14/12/24.
//



import Foundation

struct Place: Decodable {
    let id: String
    let name: String
    let description: String
    let coupons: Int
    let latitude: Double
    let longitude: Double
    let address: String
    let phone: String
    let cover: String
    let categoryId: String
    
}
