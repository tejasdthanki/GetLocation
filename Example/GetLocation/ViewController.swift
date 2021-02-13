//
//  ViewController.swift
//  GetLocation
//
//  Created by Tejas Thanki on 11/02/21.
//

import UIKit
import CoreLocation
import GetLocation
class ViewController: UIViewController {

    @IBOutlet weak var lblLocation: UILabel!
    let manager = LocationController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        // Do any additional setup after loading the view.
    }


    @objc func setupLocation(){
        manager.getUserCurrentLocation { [self] (error, location) in
            if(error != nil){
                lblLocation.text = error
            }else{
                lblLocation.text = ["lat : ",String(format: "%.4f",location!.coordinate.latitude),", long: ",String(format: "%.4f",location!.coordinate.longitude)].joined()
            }
        }
    }
}

