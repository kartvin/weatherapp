//
//  ViewController.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var toastLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    var weatherRespone: WeatherResponse?
    var imageDict: Dictionary<String, Data> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetData()
        triggerSearch()
        self.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEndOnExit)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imageDict.removeAll()
    }
    
    private func triggerSearch() {
        let cityName = retrievePreviouslySearchedCity()
        if (!cityName.isEmpty) {
            self.searchField.text = cityName
            searchWeather(cityName: cityName)
        }
    }
    
    //MARK: - Service call handler
    private func searchWeather(cityName: String) {
        if (!cityName.isEmpty && isStringLegid(name: cityName)) {
            self.loaderView.isHidden = false;
            
            //Makes service call and load the tableview on completion or throws an error on failure
            ServiceManager.sharedInstance.getCurrentWeather(city:cityName, completion: {  (result : WeatherResponse) in
                self.loaderView.isHidden = true;
                self.weatherRespone = result
                self.populateDate()
                self.saveSearchCity(cityName: cityName)
            }) { (error : NSError) in
                self.toastLabel.text = error.localizedDescription
                self.spinner.stopAnimating()
                self.showErrorAlert(errorMessage: error.localizedDescription)
                self.resetData()
            }
        }else{
            resetData()
            showErrorAlert(errorMessage: "Please enter a valid city name and try again!")
        }
    }
    
    //MARK: - Managing userdefaults
    private func saveSearchCity(cityName:String) {
        if (cityName.isEmpty) {
            return
        }
        UserDefaults.standard.set(cityName, forKey: "city")
        UserDefaults.standard.synchronize()
        
    }
    
    private func retrievePreviouslySearchedCity() -> String {
        if (nil !=  UserDefaults.standard.value(forKey: "city")) {
            return UserDefaults.standard.value(forKey: "city") as! String
        }else {
            return ""
        }
    }
    
    //MARK: - data population methods
    
    private func populateDate() {
        guard let response = self.weatherRespone else {
            resetData()
            return
        }
        
        temparatureLabel.text = String(response.temp)
        humidityLabel.text = String(response.humidity)
        pressureLabel.text = String(response.pressure)
        minTempLabel.text = String(response.temp_min)
        maxTempLabel.text = String(response.temp_max)
        cityLabel.text = response.name
        self.tableView.reloadData()
    }
    
    private func resetData() {
        let str = "NA"
        temparatureLabel.text = str
        humidityLabel.text = str
        pressureLabel.text = str
        minTempLabel.text = str
        maxTempLabel.text = str
        cityLabel.text = str
        
        self.weatherRespone = nil
        self.tableView.reloadData()
    }
    
    //MARK: - Util methods
    private func isStringLegid(name: String) -> Bool {
        for char in name.characters {
            if (!(char >= "a" && char <= "z") && !(char >= "A" && char <= "Z") && char != " ") {
                return false
            }
        }
        return true
    }
    
    private func showErrorAlert(errorMessage : String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - textField notification receiver
    func textFieldDidChange(_ textField: UITextField) {
        let cityName = searchField.text ?? ""
        searchWeather(cityName: cityName)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        let weatherItem = self.weatherRespone?.weatherList[indexPath.row]
        
        cell.textLabel?.text = weatherItem?.main
        cell.detailTextLabel?.text = weatherItem?.weatherDescription
        if (!weatherItem!.iconUrl.isEmpty) {
            if (nil != self.imageDict[weatherItem!.iconUrl]) {
                cell.imageView?.image = UIImage(data:self.imageDict[weatherItem!.iconUrl]!)
            }else {
                cell.imageView?.downloadImage(link: (weatherItem?.iconUrl)!, completion: { (imgData, imgURL) in
                    self.imageDict[imgURL] = imgData
                })
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = self.weatherRespone {
            return response.weatherList.count
        } else {
            return 0
        }
    }
    
}


