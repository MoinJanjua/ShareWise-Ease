//
//  RecordsViewController.swift
//  POS
//
//  Created by Maaz on 10/10/2024.
//

import UIKit

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var createbtn: UIButton!
    
    var order_Detail: [AllSales] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        addDropShadowButtonOne(to: createbtn)

    }
    override func viewWillAppear(_ animated: Bool) {
        // Load data from UserDefaults
        // Retrieve stored medication records from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "OrderDetails") as? [Data] {
            let decoder = JSONDecoder()
            order_Detail = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(AllSales.self, from: data)
                    return order
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
     TableView.reloadData()
    }
    
    @IBAction func CreateSales(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
       // self.tabBarController?.selectedIndex = 3
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
  
}
extension RecordsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order_Detail.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! RecordsTableViewCell

        let OrderData = order_Detail[indexPath.row]
        cell.productNameLbl?.text = OrderData.product
        cell.orderNumLbl?.text = OrderData.SaleType
        cell.usernameLabel?.text = OrderData.userName

        // Convert the Date object to a String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Match this format to saved data
        let dateString = dateFormatter.string(from: OrderData.DateOfOrder)
        
        // Assign the formatted date string to the label
        cell.dateLbl.text = dateString

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            order_Detail.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try order_Detail.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "OrderDetails")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let orderData = order_Detail[indexPath.row]
    
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let newViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailViewController") as?                      OrderDetailViewController {
            newViewController.selectedOrderDetail = orderData
       
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
            
        }
        
    }
 }


