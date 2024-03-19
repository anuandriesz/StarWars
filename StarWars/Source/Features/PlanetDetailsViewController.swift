//
//  PlanetDetailsViewController.swift
//  StarWars
//
//  Created by Anuradha Andriesz on 2024-03-18.
//

import UIKit

class PlanetDetailsViewController: UIViewController {
    var planetN: String = ""

    @IBOutlet weak var lblPlanetname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPlanetname.text = " Welcome to \(planetN)"
    }
}
