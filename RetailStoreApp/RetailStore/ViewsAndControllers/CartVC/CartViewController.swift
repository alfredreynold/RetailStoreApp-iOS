//
//  CartViewController.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/14/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit
import RetailStoreModel
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var user:User?
    var cartFetchedResultController:NSFetchedResultsController<Item>?
    let cartCellIdentifier = "cartCellIdentifier"
    let segueCartToDetails = "segueCartToDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var total:Float = 0.00
        
        if let items = user?.items?.allObjects as? [Item] {
            for item in items {
                total += item.price
            }
        }
        self.totalAmountLabel.text = "Rs. \(total)"
        
        let nib = UINib(nibName: "RSCartTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cartCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 44.0
        self.title = "Cart"
        loadData()
    }
    
    func loadData() {
        guard let confirmeduser = self.user else { return }
        if cartFetchedResultController == nil {
            let request = NSFetchRequest<Item>(entityName: "Item")
            let predicate = NSPredicate(format: "user.id == %d", confirmeduser.id)
            request.predicate = predicate
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            cartFetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.sharedManager.context, sectionNameKeyPath: "category", cacheName: nil)
            cartFetchedResultController?.delegate = self
        }
        
        do {
            try cartFetchedResultController?.performFetch()
            tableView.reloadData()
        } catch  {
            print("Error while fetching cart items")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = cartFetchedResultController?.sections?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectInfo = cartFetchedResultController?.sections?[section] else { return 0 }
        return sectInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: cartCellIdentifier) as? RSCartTableViewCell else { return UITableViewCell(style: .default, reuseIdentifier: cartCellIdentifier) }
        
        guard let item = cartFetchedResultController?.object(at: indexPath) else { return cell }
        cell.itemName.text = item.name
        cell.itemPrice.text = "Rs. \(item.price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: segueCartToDetails, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = cartFetchedResultController?.object(at: indexPath) else { return }
            DataManager.sharedManager.container.viewContext.delete(item)
            DataManager.sharedManager.saveContext()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .delete, let indx = indexPath {
            tableView.deleteRows(at: [indx], with: UITableViewRowAnimation.automatic)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.segueCartToDetails {
            if let indexPath = sender as? IndexPath, let item = cartFetchedResultController?.object(at: indexPath), let destVC = segue.destination as? ItemDetailsViewController {
                destVC.item = item
                destVC.user = self.user
            }
        }
    }
 

}
