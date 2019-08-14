//
//  QuoteTableViewController.swift
//  UDEMY-1-19-InspoQuotes
//
//  Created by Destiny Sopha on 8/9/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import StoreKit // includes the functionality needed in invoke our In-App purchase for a virtual product

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
  
  let productID = "com.OverTheMoonApps.UDEMY_1_19_InspoQuotes.PremiumQuotes"
  
  var quotesToShow = [
    "Our greatest glory is not in never falling, but in rising every time we fall. - Confucius",
    "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
    "It does not matter how slowly you go as long as you do not stop. – Confucius",
    "Everything you’ve ever wanted is on the other side of fear. – George Addair",
    "Success is not final; failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
    "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
  ]
  
  let premiumQuotes = [
    "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. Roy T. Bennet",
    "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
    "There is only one thing that makes a dream impossible to achieve: the fear of failure. – Paulo Coelho",
    "It’s not whether you get knocked down. It’s whether you get up. Vince Lombardi",
    "Your true success in life begins only when you make the commitment to become excellent at what you do. – Brian Tracy",
    "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set our selves (the QuoteTableViewController class) as the observer
    SKPaymentQueue.default().add(self)
    
    if isPurchased() {
      showPremiumQuotes()
    }
    
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isPurchased() {
      return quotesToShow.count
    } else {
      return quotesToShow.count + 1
    }
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
    
    if indexPath.row < quotesToShow.count{
      cell.textLabel?.text = quotesToShow[indexPath.row]
      cell.textLabel?.numberOfLines = 0
      cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      cell.accessoryType = .none
    } else {  // Create the last cell
      cell.textLabel?.text = "Get More Quotes"   // Add the text "Get More Quotes" to the last cell
      cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)             // Change the text color to match the app header
      cell.accessoryType = .disclosureIndicator  // Add the chevron to the right end of the cell
    }
    
    return cell
  }
  
  
  // MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == quotesToShow.count {     // The last "Get More Quotes" cell has been pressed
      buyPremiumQuotes()                        // so run the buyPremiumQuotes method
      
    }
    
    tableView.deselectRow(at: indexPath, animated: true)   // deselects the "Get More Quotes" cell
  }
  
  
  // MARK: - In-App purchase methods
  
  func buyPremiumQuotes() {
    
    if SKPaymentQueue.canMakePayments() { // The user is authorized to make payments
      
      let paymentRequest = SKMutablePayment()
      paymentRequest.productIdentifier = productID
      SKPaymentQueue.default().add(paymentRequest)
      
    } else {  // the can't make payments (maybe blocked by Parental Controls
      
      print("User can't make payments")
    }
    
  }
  
  // This method will inform us when the payment has been updated in the payment que
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
    for transaction in transactions {
      if transaction.transactionState == .purchased {     // The user's payment was successful so it is a valid purchase
        print("Transaction was successful")
        
        showPremiumQuotes()
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
      } else if transaction.transactionState == .failed { // The user's payment failed
        
        if let error = transaction.error {
          let errorDescription = error.localizedDescription
          print("Transaction failed due to error: \(errorDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
      } else if transaction.transactionState == .restored {
        showPremiumQuotes()
        
        print("Transaction Restored")
        
        navigationItem.setRightBarButton(nil, animated: true)  // removes the Restore button from view
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
      }
    }
    
  }
  
  func showPremiumQuotes() {
    
    UserDefaults.standard.set(true, forKey: productID)

    quotesToShow.append(contentsOf: premiumQuotes) // Append the Premium Quotes array to the end of the quotesToShow array
    tableView.reloadData()
  }
  
  func isPurchased() -> Bool {
    let purchasedStatus = UserDefaults.standard.bool(forKey: productID)
    if purchasedStatus { // is true, then the user has already purchased the Premium Quotes
      print("Previously Purchased")
      return true
    } else {  // if not true, then the user has not purchased the Premium QUotes
      print("Never Purchased")
      return false
      
    }
    
  }
  
  @IBAction func restorePressed(_ sender: UIBarButtonItem) {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
}
