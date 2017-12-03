
import Foundation
import UIKit
import CoreLocation
let clientID:String = "c6257d08db2940eb93d0762285ba7336"
let clientSecred:String = "185e9b81a080488f927205809d342172"
let redirectURI:String = "https://elfsight.com/service/generate-instagram-access-token/"
let accessToken:String = "1460375259.e029fea.9ce0f615005b4234a9ea7ce3ffe0d243"
var ourLocation:CLLocation!
var arrOfImgs = [imgCache]()

//var arrOfAges = [Int]()
//var arrOfGender = [Bool]()

class imgCache {
    var image:String = ""
    var likes:Int = 0
}


extension UIImageView {
    public func imageFromUrl(_ urlString: String) {
        self.image = nil
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                if (data != nil) {
                    self.image = UIImage(data: data!)
                }
            }}
    }
}
