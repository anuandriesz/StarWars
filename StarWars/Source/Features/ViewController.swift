//
//  ViewController.swift
//  StarWars
//
//  Created by Anuradha Andriesz on 2024-03-13.
//

import UIKit
// This is a ViewController class that inherits from UIViewController.
class ViewController: UIViewController {
    var planetsVM = PlViewModel()
    var lastPlanet = Planets()
    
    @objc func handleDataLoadedNotification() {
        updatePlanets()
    }
    
    // IBOutlet properties to connect UI elements from Interface Builder
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var tVPlanets: UITableView!

    // This method is called after the view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for the notification
            NotificationCenter.default.addObserver(self, selector: #selector(handleDataLoadedNotification), name: Notification.Name("DataLoadedNotification"), object: nil)

        
        let nib = UINib(nibName: "DemoTableViewCell", bundle:nil)
        tVPlanets.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        
        // Assigning delegate and dataSource to the tableView.
        tVPlanets.delegate = self
        tVPlanets.dataSource = self
   
        Task{
            await  planetsVM.getData()
        }
    }

    
    func updatePlanets() {
        // Reload the table view after fetching
        DispatchQueue.main.async {
            self.tVPlanets.reloadData()
        }
    }

}

// Extension for ViewController conforming to UITableViewDelegate.
extension ViewController: UITableViewDelegate {
    // This method is called when a row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlanetDetails") as? PlanetDetailsViewController;
        vc?.title = "Details"
        vc?.planetN = planetsVM.planetsArray[indexPath.row].name
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
}


//Similer to interfaces
// Extension for ViewController conforming to UITableViewDataSource.
extension ViewController: UITableViewDataSource {
    // This method returns the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planetsVM.planetsArray.count
    }
    
    // This method configures and returns a cell for a given indexPath.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell with identifier "cell".
        let cell = tVPlanets.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
        // Set the text label of the cell to the name of the planet.
        cell.name.text = planetsVM.planetsArray[indexPath.row].name
        // Load image from URL
                if let imageURL = URL(string: "https://picsum.photos/100/") {
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageURL) {
                            DispatchQueue.main.async {
                                // Set image to the UIImageView
                                cell.imgView.image = UIImage(data: imageData)
                                cell.imgView.layer.cornerRadius = 4
                            }
                        }
                    }
                }
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Calculate the position of the scroll view content.
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Check if the user has scrolled to the bottom of the table view.
        if offsetY > contentHeight - height {
            ///extract the last planet
            lastPlanet = planetsVM.planetsArray.last!
            Task {
             await   planetsVM.loadNextPage(planets: lastPlanet)
            }
        }
    }
}
