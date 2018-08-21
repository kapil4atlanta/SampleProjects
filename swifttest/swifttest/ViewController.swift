//
//  ViewController.swift
//  swifttest
//
//  Created by Kapil Rathan on 6/22/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var swipedCards: [String] = ["4512342256","2312344456","5612355456","4512333456","1212345556","7612366456","1244344456"]
    var cardPrefixes: [String] = ["12", "76"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        let cards = validateCards(swipedCards: swipedCards, cardPrefixes: cardPrefixes)
        print(cards)
        var f: Float = 3
        var va1 = 1...5
        


        var counter = 0
        let key = 5
        let array = contigous(numbers: [3,4,5])
        for num in array{
            if num < key{
                counter = counter + 1
            }
        }
        print(counter)
    }
    
    func contigous(numbers: [Int]) -> [Int]{
        var subarrays : [[Int]] = []
        var arry: [Int] = []
        var sum = 1
        
        for i in 0..<numbers.count{
            for j in i..<numbers.count{
                for k in i...j{
                    print(numbers[k])
                    arry.append(numbers[k])
                }
                subarrays.append(arry)
                arry.removeAll()
            }
        }
        for arr in subarrays{
            for num in arr{
                sum = sum * num
            }
            arry.append(sum)
            sum = 1
        }
        return  arry
    }
    
    func validateCards(swipedCards: [String], cardPrefixes: [String]) -> [Card]{
        var returnVal: [Card] = []
        
        for scard in swipedCards{
            var card = Card(card: scard)
            card.isValid = checkifValid(number: scard)
            card.isAllowed = checkifAllowed(cardnumber: scard, prefixes: cardPrefixes)
            returnVal.append(card)
        }

        return returnVal
        
    }
    
    func checkifAllowed(cardnumber: String, prefixes: [String]) -> Bool{
        var returnVal: Bool = true
        
        for prefix in prefixes{
            if cardnumber.prefix(prefix.count) == prefix{
                returnVal = false
                break
            }
        }
        
        return returnVal
        
    }
    
    func checkifValid(number: String) -> Bool{
        var returnVal: Bool = false
        var intArray: [Int] = []
        
        for char in number{
            let stringVal  = String(char)
            let IntVal = Int(stringVal)
            let double = IntVal! * 2
            intArray.append(double)
        }
        
        var sum = 0
        for i in 0..<intArray.count-1{
            sum = sum + intArray[i]
        }
        
        returnVal = (sum % 10) == (intArray.last! / 2)
        
        return returnVal
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

