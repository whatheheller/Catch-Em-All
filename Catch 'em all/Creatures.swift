

import Foundation

class Creatures {
    
    private struct Returned: Codable {
        var count: Int
        var next: String?
        var results: [Creature]
    }
    
    struct Creature: Codable {
        var name = ""
        var url = ""
    }
    
    var count = 0
    var urlString = "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"
    var creatureArray: [Creature] = []
    
    func getData (completed: @escaping ()->()) {
        print("We are acessing URL \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create URL from \(urlString)")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                print("Here is what was returned \(returned)")
                self.creatureArray = self.creatureArray + returned.results
                self.urlString = returned.next ?? ""
                self.count = returned.count
            } catch {
                print("JSON ERROR")
            }
            completed()
        }
        task.resume()
    }
}
