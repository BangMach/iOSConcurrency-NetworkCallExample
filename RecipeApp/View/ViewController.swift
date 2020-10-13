//
//  ViewController.swift
//  RecipeApp
//
//  Created by Mach Dieu Bang on 2/29/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource,Refresh {
    var viewModel = RecipeViewModel()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // call that cell based on it unique indentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        // give the element in the story board a unique tag
        // reference it in the code
        // cast it as UIELement necessary
        let title = cell.viewWithTag(1000) as! UILabel
        let ingredients = cell.viewWithTag(1001) as! UILabel
        let imageView = cell.viewWithTag(1002) as! UIImageView
        
        title.text = viewModel.getTitleFor(index: indexPath.row)
        ingredients.text = viewModel.getIngredients(index: indexPath.row)
        imageView.image = viewModel.getImageFor(index: indexPath.row)
        
        return cell
    }

    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var ingredients: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func SearchBt(_ sender: Any) {
        //one of the few times when we are allowed to force unwrapped, the ONLY time it will crash are when the table not connected correctly
        let inputIngredient =  self.ingredients.text!
        let inputRecipeTitle = self.recipeTitle.text!
        // executing the network call from the background thread with -QoS: .utility for task that can take 1 or 2 minutes to complete 
        DispatchQueue.global(qos: .utility).async {
            self.viewModel.getRecipe(with: inputIngredient, andNamed: inputRecipeTitle)
        }
    }
    
    func updateUI() {
          tableView.reloadData()
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        viewModel.delegate = self
        // the view controller is telling the view model that it want to be its delegate(observed)
        
        // Do any additional setup after loading the view.
    }


}

