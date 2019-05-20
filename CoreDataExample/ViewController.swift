//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Vitaliy on 8/24/18.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users = [Persone]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdent") as! itemCell
        let user = users[indexPath.row]
        cell.Name.text = user.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Change user", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Change", style: .default) {(action) in
            self.users[indexPath.row].setValue(textField.text, forKey: "Name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTF) in
            textField = alertTF
            textField.placeholder = "New user"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            context.delete(users[indexPath.row])
            users.remove(at: indexPath.row)
            saveData()
        default:
            return
        }
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<Persone> = Persone.fetchRequest()
        
        do {
            users = try context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func createUser(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New user", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            let newUser = Persone(context: self.context)
            newUser.name = textField.text
            self.users.append(newUser)
            self.saveData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTF) in
            textField = alertTF
            textField.placeholder = "New user"
        }
        present(alert, animated: true, completion: nil)
    }
}

