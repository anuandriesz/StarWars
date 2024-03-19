//
//  Planets.swift
//  StarWars
//
//  Created by Anuradha Andriesz on 2024-03-18.
//

import Foundation
struct Planets: Identifiable, Codable {
    let id = UUID().uuidString
    var name = ""
    var orbital_period = ""
    var climate = ""
    var gravity = ""
    
/// coding keys are set since we are not getting any keys from the JSON file.
    enum CodingKeys: CodingKey {
        case name, orbital_period, climate, gravity
    }
}
