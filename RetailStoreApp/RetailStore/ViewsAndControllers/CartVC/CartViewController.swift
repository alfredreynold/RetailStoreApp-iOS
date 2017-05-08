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
        
        updateTotal()
        let nib = UINib(nibName: "RSCartTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cartCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 44.0
        self.title = "Cart"
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func updateTotal() {
        var total:Float = 0.00
        
        if let items = user?.items?.allObjects as? [Item] {
            for item in items {
                total += (item.price * Float(item.quantity))
            }
        }
        self.totalAmountLabel.text = "Rs. \(total)"
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
        
        if let name = item.name {
            cell.itemName.text = "\(name) * \(item.quantity)"
        } else {
            cell.itemName.text = ""
        }
        
        let itemPrice = item.quantity > 0 ? item.price * Float(item.quantity) : item.price
        cell.itemPrice.text = "Rs. \(itemPrice)"
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
            user?.removeFromItems(item)
            item.user = nil
            DataManager.sharedManager.saveContext()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer:sectionIndex), with: .automatic)
            break
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indxP = indexPath else { return }
        switch type {
        case .delete:
            tableView.deleteRows(at: [indxP], with: .automatic)
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        updateTotal()
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
