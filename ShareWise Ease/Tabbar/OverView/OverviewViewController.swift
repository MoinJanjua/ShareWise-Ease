//
//  OverviewViewController.swift
//  ShareWise Ease
//
//  Created by Maaz on 16/10/2024.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var detailMianView2: UIView!
    @IBOutlet weak var SaleRepairSegment: UISegmentedControl!
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var todaySalesAmount: UILabel!
    @IBOutlet weak var totalSalesAmount: UILabel!
    
    var order_Detail: [AllSales] = [] // This contains all the orders
    var filteredOrders: [AllSales] = [] // This will contain the filtered orders
    
    var currency = String()


    override func viewDidLoad() {
        super.viewDidLoad()

        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        addDropShadow(to: detailMianView2)
        
        TableView.dataSource = self
        TableView.delegate = self
        
        // Set default segment to 0 (All orders)
        SaleRepairSegment.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"

        // Load data from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "OrderDetails") as? [Data] {
            let decoder = JSONDecoder()
            order_Detail = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(AllSales.self, from: data)
                    return order
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        // Calculate sales amounts
        calculateSalesAmounts()
        
        // Apply initial filter (all orders by default)
        filterOrdersBySegment()
    }
    
    @IBAction func SRsegment(_ sender: UISegmentedControl) {
        // Filter the orders when the segment changes
        filterOrdersBySegment()
    }
    
    func filterOrdersBySegment() {
        let selectedSegment = SaleRepairSegment.selectedSegmentIndex
        
        switch selectedSegment {
        case 0:
            // Show all orders
            filteredOrders = order_Detail
        case 1:
            // Filter for sales
            filteredOrders = order_Detail.filter { $0.SaleType == "Sales" }
        case 2:
            // Filter for repairs
            filteredOrders = order_Detail.filter { $0.SaleType == "Repairs" }
        default:
            // Default to show all orders
            filteredOrders = order_Detail
        }
        
        // Reload the table view with filtered data
        TableView.reloadData()
    }
    
    // Function to calculate the total and today's sales amounts
    func calculateSalesAmounts() {
        let today = Date()
        let calendar = Calendar.current
        
        // Format today's date to compare with order dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let todayString = dateFormatter.string(from: today)
        
        var totalSales: Double = 0.0
        var todaySales: Double = 0.0
        
        // Loop through all orders to calculate the total sales and today's sales
        for order in order_Detail {
            // Convert amount to Double (assuming it's a valid number)
            if let amount = Double(order.amount) {
                // Add to total sales
                totalSales += amount
                
                // Check if the order date is today
                let orderDateString = dateFormatter.string(from: order.DateOfOrder)
                if orderDateString == todayString {
                    todaySales += amount
                }
            }
        }
        
        // Update labels with the calculated values
        totalSalesAmount.text = String(format: "\(currency)%.2f", totalSales)   // "\(currency) \(totalSales)"
        todaySalesAmount.text = String(format: "\(currency)%.2f", todaySales)   //  "\(currency) \(todaySales)"
    }
    
    @IBAction func ViewAllSalesbutton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewSalesViewController") as! ViewSalesViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func CurrenctButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CurrencyViewController") as! CurrencyViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    
}

extension OverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrders.count // Use filtered orders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as! OverviewTableViewCell
        
        let OrderData = filteredOrders[indexPath.row] // Use filtered orders
        cell.productNameLbl?.text = OrderData.product
        cell.salesTypeLabel?.text = OrderData.SaleType
        cell.saleMenNameLabel?.text = OrderData.userName
        cell.amountOFProductLabel?.text = "\(currency) \(OrderData.amount)"

        
        // Convert the Date object to a String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Match this format to saved data
        let dateString = dateFormatter.string(from: OrderData.DateOfOrder)
        
        // Assign the formatted date string to the label
        cell.dateLbl.text = dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
