//
//  ItemDetailsViewController.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/14/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit
import RetailStoreModel

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    var user:User?
    var item:Item?
    
    @IBOutlet weak var counter: UIStepper!
    @IBOutlet weak var quantityValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let iItem = self.item {
            itemNameLabel.text = iItem.name
            itemPriceLabel.text = "Rs. \(iItem.price)"
            itemImageView.image = UIImage(named: iItem.imageUrl ?? "cart")
            counter.value = Double(iItem.quantity)
            quantityValueLabel.text = "\(counter.value)"
        }
        
    }
    @IBAction func counterValueChanged(_ sender: UIStepper) {
        if let iItem = self.item, sender.value > 0 {
            iItem.quantity = Int16(Int(sender.value))
            quantityValueLabel.text = "\(sender.value)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DataManager.sharedManager.saveContext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        if let iUser = self.user, let iItem = self.item {
            iUser.addToItems(iItem)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemDetailsToCart" {
            if let cartVc = segue.destination as? CartViewController {
                cartVc.user = self.user
            }
        }
    }
 

}
