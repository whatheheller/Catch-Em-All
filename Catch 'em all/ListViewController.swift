

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var creatures = Creatures()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupActivityIndicator()
        
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        creatures.getData {
            DispatchQueue.main.async {
                self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .red
        view.addSubview(activityIndicator)
    }
    
    func loadAll() {
        if creatures.urlString.hasPrefix("http") {
            creatures.getData {
                DispatchQueue.main.async {
                    self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                    self.tableView.reloadData()
                }
                self.loadAll()
            }
        } else {
            DispatchQueue.main.async {
                print("All pokemon loaded. Total count is \(self.creatures.creatureArray.count)")
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }

    @IBAction func loadAllPressed(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        loadAll()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatures.creatureArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == creatures.creatureArray.count-1 && creatures.urlString.hasPrefix("http") {
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            creatures.getData {
                DispatchQueue.main.async {
                    self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "\(indexPath.row+1). \(creatures.creatureArray[indexPath.row].name)"
    return cell
    }
}
