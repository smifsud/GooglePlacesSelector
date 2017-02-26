//
//  ViewController.swift
//  GooglePlacesSelector
//
//  Created by smifsud on 02/25/2017.
//  Copyright (c) 2017 smifsud. All rights reserved.
//

import UIKit
import GooglePlacesSelector

class ViewController: GooglePlacesSelector{
    
    override func viewDidLoad() {
        // set Google Places Web API Key - ** NOT ** iOS key
        self.setKey(key: "GOOGLE_PLACES_WEB_API_KEY");
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

