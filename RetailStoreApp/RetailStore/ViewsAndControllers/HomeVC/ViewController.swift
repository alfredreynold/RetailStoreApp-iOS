//
//  ViewController.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/13/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit
import CoreData
import RetailStoreModel

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartItemsCountLabel: UILabel!
    
    
    let tableViewCellIdentifier = "RSCell"
    let segueFromCellToItemDetails = "segueFromCellToItemDetails"
    let segueToCartVC = "segueToCartVC"
    
    var fetchedResultsController:NSFetchedResultsController<Item>?
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "RSItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 90.0
        self.title = "Home"
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        
        if user == nil {
            let userRequest:NSFetchRequest<User> = User.fetchRequest()
            userRequest.sortDescriptors = []
            userRequest.fetchLimit = 1
            do {
                let users = try DataManager.sharedManager.context.fetch(userRequest)
                user = users[0]
                self.userNameLabel.text = "Hi, \(user?.name ?? String())"
            } catch {
                print("Failed To load user")
            }
        }
        
        if let count = user?.items?.count, count > 0 {
            self.cartItemsCountLabel.text = "\(count)"
        } else {
            self.cartItemsCountLabel.text = ""
        }
        
        if fetchedResultsController == nil {
            let request:NSFetchRequest<Item>  = Item.fetchRequest()
            let catsort = NSSortDescriptor(key: "category", ascending: true)
            let namesort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [catsort,namesort]
            request.fetchBatchSize = 10
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.sharedManager.container.viewContext, sectionNameKeyPath: "category", cacheName: nil)
            fetchedResultsController?.delegate = self
        }
        
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch  {
            print("Error while fetching data")
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = fetchedResultsController?.sections?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController?.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier) as? RSItemTableViewCell else { return  UITableViewCell(style: .default, reuseIdentifier: tableViewCellIdentifier)}
        
        guard let item = fetchedResultsController?.object(at: indexPath) else { return cell }
        
        cell.itemNameLabel.text = item.name
        cell.itemPriceLabel.text = "Rs. \(item.price)"
        cell.itemImageView.image = UIImage(named: item.imageUrl ?? "cart")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController?.sections?[section], let item = sectionInfo.objects?[0] as? Item else { return nil }
        return item.category
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: segueFromCellToItemDetails, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueFromCellToItemDetails {
            if let indexPath = sender as? IndexPath, let item = fetchedResultsController?.object(at: indexPath), let destVC = segue.destination as? ItemDetailsViewController {
                destVC.item = item
                destVC.user = self.user
            }
        } else if segue.identifier == segueToCartVC {
            if let destVC = segue.destination as? CartViewController {
                destVC.user = self.user
            }
        }
    }
    
}

