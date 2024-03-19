//
//  PlViewModal.swift
//  StarWars
//
//  Created by Anuradha Andriesz on 2024-03-19.
//

import Foundation

@MainActor

class PlViewModel: ObservableObject {
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    struct Returned: Codable {
        var next : String!
        var results: [Planets]
    }
    
    @Published var planetsArray: [Planets] = []
    @Published var isLoading = false
    var appError: AppError? = nil
    var urlString = "https://swapi.dev/api/planets/"
    
    func getData() async {
        isLoading = true
        print("🕸️ able to access the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: not able to convert \(urlString) to a URL")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data)
                urlString = returned.next ?? ""
                planetsArray += returned.results
                isLoading = false
                // Reload table view on the main thread
                DispatchQueue.main.async {
                               NotificationCenter.default.post(name: Notification.Name("DataLoadedNotification"), object: nil)
                           }
            } catch {
                print("😡 JSON ERROR: Could not convert data into JSON. \(error.localizedDescription)")
                isLoading = false
            }
        } catch {
            self.appError = AppError(errorString: "Data Could Not be load")
            print("😡 ERROR: could not get data from urlString \(urlString)")
            isLoading = false
        }
    }
    
    /// load the next page of data since API load 10 of planets for each call so this function will call the next set of planets until all the planets are retrived.
    func loadNextPage(planets: Planets) async {
        guard let lastPlanets = planetsArray.last else {return}
        if lastPlanets.id == planets.id &&  urlString != "" {
            await getData()
        }
    }
    
    var cardIconURL: URL {
        let urlString = "https://picsum.photos/100/"
        return URL(string: urlString)!
    }
    
}
