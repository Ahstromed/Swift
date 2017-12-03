
import Foundation
import UIKit
import CoreLocation
let clientID:String = " "
let clientSecred:String = " "
let redirectURI:String = "https://elfsight.com/service/generate-instagram-access-token/"
let accessToken:String = " "
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
