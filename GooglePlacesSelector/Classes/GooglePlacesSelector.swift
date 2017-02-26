//
//  GooglePlaceSelector.swift
//  sort
//
//  Created by Spiro Mifsud on 1/18/17.
//  Copyright © 2017 Material Cause LLC. All rights reserved.
//

import UIKit

open class GooglePlacesSelector: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate
{
    
    private var APIkey:String = "";
    
    private var tableView: UITableView!
    
    private var searchController: UISearchController!
    private let CellIdentifier = "placeCell";
    private var data = [GooglePlacesStruct]();
    private var selected_place:GooglePlacesDetailStruct!;
    private var urlString = "";
    private var detailsString = "";
    private let tableOffset = 20;
    private var imageView:UIImageView!;
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setTable();
        self.setSearchController();
        self.setDetailStruct();
        self.setGoogleImage();
    };
    
    public func setKey(key:String)
    {
        self.APIkey = key;
    };
    
    private func setDetailStruct()
    {
        self.selected_place = GooglePlacesDetailStruct(
            city : "",
            street: "",
            street_number: "",
            state: "",
            postal_code:""
        )
    };
    
    private func setGoogleImage()
    {
        let imageName = "powered-by-google-dark.png"
        let image = UIImage(named: imageName)
        self.imageView = UIImageView(image: image)
        
        self.imageView.frame = CGRect(x: (UIScreen.main.bounds.width/2)-((image?.size.width)!/2), y: 85, width: (image?.size.width)!, height: (image?.size.height)!)
        view.addSubview(self.imageView)
    };
    
    private func setTable()
    {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height - CGFloat(tableOffset)
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        tableView.backgroundColor = UIColor.init(red: 242, green: 242, blue: 242, alpha: 1)
        // Remove extra separators
        tableView.tableFooterView = UIView(frame: .zero);
        self.view.addSubview(self.tableView);
    };
    
    private func setSearchController()
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self;
        searchController.searchBar.delegate = self;
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true;
    };
    
    private func parseJson()
    {
        self.data = [GooglePlacesStruct]();
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                    if (((parsedData["predictions"] as? NSArray)?.count)! > 0)
                    {
                        for item in (parsedData["predictions"] as? [[String: Any]])! {
                            var temp  = GooglePlacesStruct(
                                id : "",
                                description : "",
                                street: "",
                                city:""
                            )
                            
                            if let description = item["description"] as? String
                            {
                                temp.description = description;
                            }
                            
                            if let property_id = item["place_id"] as? String
                            {
                                temp.id = property_id
                            }
                            
                            
                            if let property_reference:AnyObject = item["structured_formatting"] as AnyObject?
                            {
                                
                                temp.street = (property_reference["main_text"] as! String)
                                temp.city = (property_reference["secondary_text"] as! String)
                                
                            }
                            
                            self.data.append(temp);
                        }
                    }
                    else
                    {
                        self.data = [GooglePlacesStruct]();
                        
                    }
                    DispatchQueue.main.async{
                        
                        if (self.data.count == 0)
                        {
                            self.imageView.alpha = 1;
                        }
                        else
                        {
                            self.imageView.alpha = 0;
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    };
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PlaceTableViewCell = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier)as?PlaceTableViewCell)!
        
        cell.setText(line1: data[indexPath.row].street, line2: data[indexPath.row].city)
        
        return cell
    };
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    };
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.detailsString =  "https://maps.googleapis.com/maps/api/place/details/json?key="+self.APIkey+"&placeid=" + self.data[indexPath.row].id
        
        getPropertyDetails(property_id: urlString);
    };
    
    private func getPropertyDetails(property_id:String)
    {
        let url = URL(string: detailsString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    self.setDetailStruct();
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                    if let test = parsedData["result"] as AnyObject?
                    {
                        
                        for items in (test["address_components"]!! as? [[String: Any]])!
                        {
                            
                            let places_types = ((items["types"] as AnyObject))
                            
                            if  (places_types.object(at:0) as! String == "postal_code")
                            {
                                self.selected_place.postal_code = (items["short_name"] as AnyObject) as! String;
                            };
                            
                            if  (places_types.object(at:0) as! String == "administrative_area_level_1")
                            {
                                self.selected_place.state = (items["short_name"] as AnyObject) as! String;
                            };
                            
                            if  (places_types.object(at:0) as! String == "locality")
                            {
                                self.selected_place.city = (items["short_name"] as AnyObject) as! String;
                            };
                            
                            if  (places_types.object(at:0) as! String == "route")
                            {
                                self.selected_place.city = (items["short_name"] as AnyObject) as! String;
                            };
                            
                            if  (places_types.object(at:0) as! String == "street_number")
                            {
                                self.selected_place.street_number = (items["short_name"] as AnyObject) as! String;
                            }
                        };
                    };
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "place_selected"), object:self.selected_place);
                    
                    print (self.selected_place);
                }
                    
                catch let error as NSError
                {
                    print(error)
                }
            }
            
            }.resume()
    };
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print ("Cancel Button Pressed")
        // self.searchDisplayController.setActive(false, animated: true)
    };
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.imageView.alpha = 1;
        let escapedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        self.urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="+escapedString!+"&key="+self.APIkey+"&types=address"
        self.parseJson();
        self.imageView.alpha = 0;
    };
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 57;
    };
    
    override open func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    };
};



