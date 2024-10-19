//
//  UserViewController.swift
//  POS
//
//  Created by Maaz on 09/10/2024.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var addSaleMenBtn: UIButton!

    
    var SaleMens_Detail: [SalesPerson] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        addDropShadowButtonOne(to: addSaleMenBtn)

    }
    override func viewWillAppear(_ animated: Bool) {
        // Load data from UserDefaults
        // Retrieve stored medication records from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "UserDetails") as? [Data] {
            let decoder = JSONDecoder()
            SaleMens_Detail = savedData.compactMap { data in
                do {
                    let medication = try decoder.decode(SalesPerson.self, from: data)
                    return medication
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
     TableView.reloadData()
    }
    @IBAction func AddUserDetailButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
extension UserViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SaleMens_Detail.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        let UserData = SaleMens_Detail[indexPath.row]
        cell.nameLbl?.text = UserData.name
        cell.addressLbl?.text = UserData.Address
        cell.percentagelabel?.text = "\(UserData.percentage)%"
        
        if let image = UserData.pic {
            cell.ImageView.image = image
        } else {
            cell.ImageView.image = UIImage(named: "") // Set a placeholder image if no image is available
        }
        
        cell.SaleButton.tag = indexPath.row // Set tag to identify the row
        cell.SaleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }
    @objc func buttonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        print("Button tapped in row \(rowIndex)")
        let userData = SaleMens_Detail[sender.tag]
     //   let id = emp_Detail[sender.tag].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserAllDataViewController") as! UserAllDataViewController
        newViewController.tittleName = userData.name
        newViewController.percentageSet = userData.percentage

        newViewController.selectedCustomerDetail = userData
       // newViewController.userId = id
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SaleMens_Detail.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try SaleMens_Detail.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "UserDetails")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    //    let userData = SaleMens_Detail[indexPath.row]
//
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        if let newViewController = storyBoard.instantiateViewController(withIdentifier: "UserAllDataViewController") as? UserAllDataViewController {
//            newViewController.selectedCustomerDetail = userData
//        
//            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//            newViewController.modalTransitionStyle = .crossDissolve
//            self.present(newViewController, animated: true, completion: nil)
            
        }
        
    }
//    }
