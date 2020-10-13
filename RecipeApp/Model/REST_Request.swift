//
//  REST_Request.swift
//  RecipeApp
//
//  Created by Mach Dieu Bang on 2/29/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit
// One of the major problems of REST_Request is that it is a ASYNC call, meaning that the call is being handled by a BACKGROUND thread, seperated from the main UI thread. SO the information got back from the API can't be updated to the main thread after it is called.
protocol Refresh {
    func updateUI()
}
class REST_Request {
    var delegate:Refresh?
    //this delegate enable to send a message once it finish getting all its data
    var recipes:[Recipe] = []
    private let session = URLSession.shared
    // Swift API making use of the singleton pattern. because we only want 1 instance of the url session for the life cycle of the app. this is a ultility class
    private let base_url:String = "http://recipepuppy.com/api?"
    private let paramIngredient:String = "i="
    private let paramTitle:String = "q="
    private let paramPages:String = "&pg3"
    
    
    
    //MARK: a function that can be called by the viewmodel to send the url request
    func getRecipe(withIngredient:String,andNamed:String) {
        recipes=[]
        let url = base_url + paramIngredient + withIngredient + andNamed + paramPages
        //a process to clean up the URL string (get rid of spaces) to put into a URL request. this will return an optinal value
        guard let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        //form URLRequest and put the clean up url in
        if let url = URL(string: escapedAddress) {
            let request = URLRequest(url: url)
            getData(request)
        }
        
    }
    // should be internal -> set it to private
    //error escaping closure captures self mutating
    //solution change the object into class instead of struct
    /// this call the new a network call
    /// - Parameters:
    ///   - request: the URL request that have been customized the get specific data
    private  func getData(_ request:URLRequest) {
        // open the session and send the url request, this take a completion handler, which then take a closure
        // completion is for when the data has finished  and what do you want to do with it
        let task = session.dataTask(with: request, completionHandler: { data,respone,downloadError in
            
            if let error = downloadError {
                print(error)
            }
            else {
                // process the response JSON Data
                var parsedResult: Any! = nil
                // every JSON is different type, so we need to conver it to ANY type object. explicityly unwraped and set it to nil. even if there is no error we can still have an empty response with no data in it.
                // because this can cause an error when unwrapping we need to put in the do-catch statements
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    //another way of doing decoding JSON response is using JSONDecoder but I am not sure if that method is thread safe so I opt for this function
                }catch{print("JSON Serialization Unsucessful!!")}
                let result = parsedResult as! [String:Any]
                // the response we get back is an array with Key are string type and Value are any type because we don't kind of value each value has
                print(result)
                
                let allRecipes = result["results"] as! [[String:Any]]
                print(allRecipes)
                if allRecipes.count > 0
                {
                    for r in allRecipes
                    {
                        let title = r["title"] as! String
                        let url = r["href"] as! String
                        let ingredients = r["ingredients"] as! String
                        let imageName = r["thumbnail"] as! String?
                        //var image:UIImage? = nil
                        
                        
                        let recipe = Recipe(title: title, url:url,ingredients: ingredients,imageURL:imageName!)
                        self.recipes.append(recipe)
                        
                    }
                }
                /*
                 Description: once data interpretation is finished, the following instruction
                 is asking the UI to update itself
                 and you are not allowed to change the UI in the background thread
                 So we need to put it in main thread through grand central dispatch
                 */
                DispatchQueue.main.async {
                    self.delegate?.updateUI()
                }
            }
        })
        task.resume()
    }
    private init(){}
    static let shared = REST_Request()
}

