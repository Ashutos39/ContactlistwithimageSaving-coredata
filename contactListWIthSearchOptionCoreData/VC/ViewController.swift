//
//  ViewController.swift
//  contactListWIthSearchOptionCoreData
//
//  Created by Sds mac mini on 26/11/18.
//  Copyright © 2018 straightdrive.co.in. All rights reserved.
//

import UIKit
import CoreData
extension String {
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addBtnPressed: UIButton!
    @IBOutlet var cancelConst: NSLayoutConstraint!
    
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mesageShowingLbl: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
         self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        cancelConst.constant = 0.0
        getdata()
       
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        cancelConst.constant = 0.0
        searchBar.text = ""
        getdata()
        self.view.endEditing(true)
    }
    
    @IBAction func addPressed(_ sender: Any) {
      let vc = storyboard?.instantiateViewController(withIdentifier: "addcontactViewController") as! addcontactViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! showingaddressTableViewCell
        let person = people[indexPath.row]
        cell.profileName!.text = person.value(forKeyPath: "name") as! String? ?? ""
        cell.profileImg.image = UIImage(data: person.value(forKeyPath: "profileImage") as! Data)
        cell.selectionStyle = .none
        return cell
    }
    
    func getdata() {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Contact",in: managedObjectContext)
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.entity = entityDescription
        
        do {
            //go get the results
            people = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
            print("Error with request: \(error)")
        }
        tableView.isHidden = false
         self.tableView.reloadData()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        searchBar.text = ""
        cancelConst.constant = 0.0
        self.view.endEditing(true)
        tableView.isHidden = false
        getdata()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
          cancelConst.constant = 30.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        serchText(name : searchBar.text!)
    }
    
    func serchText(name : String?){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", name!)
        fetchRequest.predicate = predicate
        
        do {
            let records = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            people = records
            for record in records {
                print(record.value(forKey: "name") ?? "no name")
            }
            
            if people.count == 0{
                tableView.isHidden = true
                mesageShowingLbl.text = "No contact Found."
            }else{
                tableView.isHidden = false
            }
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
}

