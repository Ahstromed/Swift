import UIKit
import CoreLocation
import Foundation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var Fares:[(price: Int, location: String)] = []
    var Airports:[(code: String, lat: Float, lng: Float)] = []
    var domesticAirports = Set<String>()
    var global: Int = 0
    
    var textval = ""
    @IBOutlet weak var textbox: UITextField!
    @IBAction func buttonPressed(_ sender: UIButton) {
        textval = textbox.text!.uppercased()
        print (textval)
        if let path = Bundle.main.path(forResource: "Airport Codes", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: path)
                let lines = contents.components(separatedBy: "\n")
                for line in lines {
                    let words = line.components(separatedBy: "\t")
                    let f1 = (words[1] as NSString).floatValue
                    let f2 = (words[2] as NSString).floatValue
                    Airports.append((code: words[0], lat: f1, lng: f2))
                }
            } catch {
                print(error)
            }
            
        }
        if Fares.count > 0 {
            labeltext.text = "$\(Fares[global].0), \(Fares[global].1)"
            global += 1
            print("location?")
            super.viewDidLoad()
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            if (CLLocationManager.locationServicesEnabled()) {
                self.locationManager.startUpdatingLocation()
            }
            else {
                print("Not authorized to use location")
            }
            
            tableView.delegate = self
            tableView.dataSource = self
            self.refreshControl = UIRefreshControl()
            self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to reload")
            self.refreshControl!.addTarget(self, action: #selector(ViewController.reload), for: UIControlEvents.valueChanged)
            self.tableView.addSubview(refreshControl)

            
        }
        //print (Airports)

    }
    
    
    @IBOutlet weak var labeltext: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dateval = ""
    @IBAction func wheelChanged(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        global = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/YY"
        let somedateString = dateFormatter.string(from: sender.date)
        
        print(somedateString)// "somedateString" is your string date
        dateval = somedateString
        
        var Origin = [String]()
        
        if let path = Bundle.main.path(forResource: "LowestFares", ofType: "txt") {
            do {
               let contents = try String(contentsOfFile: path)
               let lines = contents.components(separatedBy: "\n")
               for line in lines {
                   let words = line.components(separatedBy: "\t")
                   let dateword = words[2].components(separatedBy: " ").first
                   //print (dateword!)
                
                   //var datehelp = dateword!
                   //datehelp.insert("0", at: datehelp.index(datehelp.startIndex, offsetBy: 2))
                   //print(datehelp)
                   Origin.append(words[0])
                   //print (dateval)
                if (words[0].lowercased() == textval.lowercased() && dateword! == dateval && words[4] == "LOWEST"){
                    print("\(words[1]) on \(dateword!) for \(words[5])")
                    //print ("before")
                    let myInt = (words[5] as NSString).integerValue
                    Fares.append((price: myInt, location: "\(words[1])"))
                    //print ("After")
                }
                //print("\(words[0]) is \(dateword!) and likes \(words[4])")
               }
                //print (Fares)
                Fares.sort(by: {$0.price < $1.price})
                print (Fares)
                if Fares.count > 0 {
                    for a in Airports{
                        domesticAirports.insert(a.0)
                    }
                    var counterF = -1;
                    for a in Fares{
                        counterF += 1
                        if !domesticAirports.contains(a.1){
                            
                            Fares.remove(at: counterF)
                            counterF = counterF-1
                        }
                    }
                    labeltext.text = "$\(Fares[0].0), \(Fares[0].1)"
                   
                        print("location?")
                        super.viewDidLoad()
                        locationManager = CLLocationManager()
                        locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        locationManager.requestWhenInUseAuthorization()
                        if (CLLocationManager.locationServicesEnabled()) {
                            self.locationManager.startUpdatingLocation()
                        }
                        else {
                            print("Not authorized to use location")
                        }
                        
                        tableView.delegate = self
                        tableView.dataSource = self
                        self.refreshControl = UIRefreshControl()
                        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to reload")
                        self.refreshControl!.addTarget(self, action: #selector(ViewController.reload), for: UIControlEvents.valueChanged)
                        self.tableView.addSubview(refreshControl)
                        
               
                }
                print (Fares)
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    
    
    
    var locationManager: CLLocationManager!
    var refreshControl:UIRefreshControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var header: UILabel!
    override func viewDidLoad() {
        print("location?")
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.startUpdatingLocation()
        }
        else {
            print("Not authorized to use location")
        }

        tableView.delegate = self
        tableView.dataSource = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to reload")
        self.refreshControl!.addTarget(self, action: #selector(ViewController.reload), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)

        
    }
    
    func reload(){
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("location has been updated")
        ourLocation = locations.last
        loadImages()
        self.locationManager.stopUpdatingLocation()
    }
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! myCell
            cell.cellImage.imageFromUrl(arrOfImgs[indexPath.row].image)
            //cell.cellImage.contentMode = .ScaleAspectFill
            return cell
    }
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            
            return arrOfImgs.count
            
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func loadImages() {
        //print("loadImages")
        OperationQueue.main.addOperation {
            var latfloat = 0.000
            var lngfloat = 0.000
            for a in self.Airports {
                //print (a.0)
                //print (self.Fares[0].1)
                if a.0 == self.Fares[self.global].1{
                    latfloat = Double(a.1)
                    lngfloat = Double(a.2)
                }
               // print (latfloat)
                //print (lngfloat)
            }
            let accessURL:String = "https://api.instagram.com/v1/media/search?lat=\(latfloat)&lng=\(lngfloat)&distance=5000&access_token=\(accessToken)"
            //print (accessURL)
            //ourLocation.coordinate.longitude
            let url = URL(string: accessURL)
            let request = NSMutableURLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(error)")
                    return
                }
                if ourLocation == nil {
                    print("No location")
                    return
                }
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    //print(responseObject)
                    if let responseDictionary = responseObject as? NSDictionary {
                        let arr = responseDictionary["data"] as? [NSDictionary]
                        arrOfImgs.removeAll()
                        for iter in arr! {
                            var temp:imgCache = imgCache()
                            let like = iter["likes"] as? NSDictionary
                            temp.likes = like!["count"] as! Int
                            let images = iter["images"] as? NSDictionary
                            let standardRes = images!["standard_resolution"] as? NSDictionary
                            let photoURL = standardRes!["url"] as! String
                            temp.image = photoURL
                            arrOfImgs.append(temp)
                            print(temp.image)
                        }
                        if arrOfImgs.count <= 1 {
                            var temp:imgCache = imgCache()
                            temp.likes = 0
                            let t = ["https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg", "https://i.pinimg.com/736x/af/b9/cb/afb9cb25f3e68bf315dbab888ebfe07a--ginger-kitten-ginger-cats.jpg", "http://www.extremecouponing.co.uk/wp-content/uploads/2016/02/buny.jpg", "https://pbs.twimg.com/media/DNQuU1zVwAAMcGr.jpg", "http://www.worldwaterforum8.org/sites/default/files/Picture%20Hassan.jpg", "https://scontent.fijd1-1.fna.fbcdn.net/v/t31.0-8/12068644_1104221152985317_3952792441538376428_o.jpg?oh=7130834fa7ef78b39fdbba2748e7f3f0&oe=5AC72DDC", "http://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=3b7472567c547ed5246c533b32d8a832", "https://www.arborday.org/images/hero/medium/hero-ring-of-trees-looking-up.jpg", "https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/JamesRiverWG.JPG/1200px-JamesRiverWG.JPG", "http://onlineclock.net/bg/rain/rain.jpg"]
                            temp.image = t[Int(arc4random_uniform(10))]
                            arrOfImgs.append(temp)
                        }
                        print("count of items: \(arrOfImgs.count)")
                    }
                    
                }
                    catch let error as NSError {
                    print(error)
                }
                DispatchQueue.main.async
                {
                    
                        arrOfImgs.sort(by: {$0.likes > $1.likes})
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                }
                

            }
            
            task.resume()
            
        }
        
    }

}

