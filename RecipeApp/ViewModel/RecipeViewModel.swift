//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Mach Dieu Bang on 3/1/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit
//instantating a REST_Requuest that has a singleton in it, and it is a ultility class. SO we should only have 1 instance of the rest request in the app, SO we make the rest request a singleton as well

// contacting the model on behalf of the view controller and simplify the data functions
struct RecipeViewModel {
    private var model = REST_Request.shared
    
    
   var delegate: Refresh?{
       get{
           return model.delegate
       }
       set (value)
       {
           model.delegate = value
       }
   }
    var count:Int {
        return recipes.count
    }
    var recipes:[Recipe] {
        return model.recipes
    }
    
    func getTitleFor(index:Int) ->String {
        return recipes[index].title
    }
    
    func getIngredients(index:Int)->String {
        return recipes[index].ingredients
    }

    func getImageFor(index:Int) -> UIImage? {
        let url = recipes[index].imageURL
        // need to create an image from data
        guard let imageURL = URL(string: url) else {return nil}
        let data = try? Data(contentsOf: imageURL)
        let image:UIImage? = nil
        if let imageData = data {
            return UIImage(data: imageData)
        }
        return image
    }
    
    func getRecipe(with ingredients:String,andNamed: String) {
        model.getRecipe(withIngredient: ingredients,andNamed: andNamed)
    }
}
