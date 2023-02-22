//
//  ViewController.swift
//  SimpleCoreData
//
//  Created by Saiful Islam on 12/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var addButton = UIButton()
    lazy var tableView = UITableView()
    
    private let coreData = CoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupButton()
    }
}

extension ViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupButton() {
        view.addSubview(addButton)
        addButton.setBackgroundImage(.add, for: .normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc func showUpdateForm(_ firstName:String, _ lastName:String, _ email:String){
            let alert = UIAlertController(
                title: "Update",
                message: "Fill the form below to add update user",
                preferredStyle: .alert
            )
        
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "First Name"
                textField.text = firstName
            })
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Last Name"
                textField.text = lastName
            })
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Email"
                textField.text = email
                textField.isEnabled = false
            })
            
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] action in
                guard let self = self else {
                    return
                }
                
                if alert.textFields![0].text!.isEmpty || alert.textFields![1].text!.isEmpty || alert.textFields![2].text!.isEmpty {
                    let warning = UIAlertController(title: "Warning", message: "Fill all the textfields", preferredStyle: .alert)
                    warning.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(warning, animated: true)
                } else {
                    self.coreData.update(alert.textFields![0].text!, alert.textFields![1].text!, alert.textFields![2].text!)
                    
                    let success = UIAlertController(title: "Success", message: "Data user updated", preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(success, animated: true)
                    
                    self.tableView.reloadData()
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    
    @objc func didTapAddButton() {
        let alert = UIAlertController(
            title: "New",
            message: "Fill the form below to add new user",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "First Name"
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Last Name"
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Email"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
            guard let self = self else {
                return
            }
            
            if alert.textFields![0].text!.isEmpty || alert.textFields![1].text!.isEmpty || alert.textFields![2].text!.isEmpty {
                let warning = UIAlertController(title: "Warning", message: "Fill all the textfields", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(warning, animated: true)
            }else {
                self.coreData.create(firstName: alert.textFields![0].text!, lastName: alert.textFields![1].text!, email: alert.textFields![2].text!)
                
                let success = UIAlertController(title: "Success", message: "Data user added", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(success, animated: true)
                
                self.tableView.reloadData()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreData.retrieve().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = coreData.retrieve()
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")!
        cell.textLabel?.text = "\(user[indexPath.row].firstName) \(user[indexPath.row].lastName) \(user[indexPath.row].email)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = coreData.retrieve()
        showUpdateForm(user[indexPath.row].firstName, user[indexPath.row].lastName, user[indexPath.row].email)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreData.delete(coreData.retrieve()[indexPath.row].email)
            tableView.reloadData()
        }
    }
}

