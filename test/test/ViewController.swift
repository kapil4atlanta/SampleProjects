//
//  ViewController.swift
//  test
//
//  Created by RATHAN, KAPILDEV on 6/21/18.
//  Copyright © 2018 home. All rights reserved.
//

import UIKit
import AVFoundation

struct Pizza{
  let ingredients: [String]
}
protocol Pizzeria{
  func makePizza(ingredients: [String]) -> Pizza
//  func makeMargharita() -> Pizza
}

extension Pizzeria{
  func makeMargharita() -> Pizza {
    return makePizza(ingredients: ["tomato", "cheese"])
  }
}


class Lombardia: Pizzeria {
  func makePizza(ingredients: [String]) -> Pizza {
    return Pizza(ingredients: ingredients)
  }
  
  func makeMargharita() -> Pizza {
    return makePizza(ingredients: ["tomato", "Basil", "cheese"])
  }
}
extension ViewController{
  var test: String{
    return "testing"
  }
  func testing(aa:String){
    print(test + aa)
  }
}
class ViewController: UIViewController {
  
  var a = "abc"
  var b = "defwxyz"
  var mixed = ""
  var couponDict:[String: Any] = ["upc": "", "code": "", "category":"", "itemPrice" : 0.0, "couponAmount": 0.0]
  var player: AVPlayer?
  var playerisPaused: Bool = true
  var testingop: String!
  
  @IBAction func didPressDetail(_ sender: Any) {
    let detailVC = TestTableViewController()
    detailVC.dataSource = ["Test1", "Test2", "Test3", "Test1", "Test2", "Test3"]
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    testingop = nil
    print(testingop)
    testing(aa: "test")
    // Do any additional setup after loading the view, typically from a nib.
    
//    let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//    player = AVPlayer(url: videoURL!)
//    let playerLayer = AVPlayerLayer(player: player)
//    playerLayer.frame = self.view.bounds
//    self.view.layer.addSublayer(playerLayer)
//    player?.play()
//    playerisPaused = false
//    
//    NotificationCenter.default.addObserver(self, selector:#selector(AVModeChanged), name: NSNotification.Name("AVPlayerAvailableHDRModesDidChangeNotification"), object: nil)
//
//    
    let ll = SingleLinkedList<String>()
    let alphabets = "ABC"
    
    for char in alphabets{
      ll.append(value: String(char))
    }
    
    ll.deleteNode(at: 2)
    
    ll.printList()
    ll.printReverse()
    
    checkArrayContainsString()
    
    customSort()
    customSortUsingSets()
  
    mergeArrys(Array1: [-3, 0, 3], Array2: [-5,-3, -1, 1, 9, 11, 21])
    
    let lombar1: Pizzeria = Lombardia()
    let lombard2: Lombardia = Lombardia()
    
    lombar1.makeMargharita()
    lombard2.makeMargharita()
    
    let bal1 = isBalanced(sequence: ["{","[","(","]",")","}"])
    let bal2 = isBalanced(sequence: ["{","[","(",")","]","}"])
    
    print(bal1)
    print(bal2)
    var s = "my.song.mp3 11b\ngreatSong.flac 1000b\nnot3.txt 5b\nvideo.mp4 200b\ngame.exe 100b\nmovie.mkv 10000b"
   
    let ot = solution(&s)
    print(ot)
    
    let dict = ["location": "garden"]
    if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
      if let content = String(data: json, encoding: String.Encoding.utf8) {
        // here `content` is the JSON dictionary containing the String
        print(content)
      }
    }
    
    fibonacci(7)
    fibonacciRecursiveNum1(0, num2: 1, steps: 7)
  }
  
  func fizzbuzz() {
    let stringA : String = "20"
    let stringB: String = "25"
    if let inta: Int = Int(stringA){
      print(inta * inta)
    }
    

    
    var M: Int = 0
    var N: Int = 0
    
    if let temp: Int = Int(stringA), let tmp: Int = Int(stringB){
      M = temp
      N = tmp
      
      for i in M...N{
        if i % 3 == 0 && i % 5 == 0{
          print("FizzBuzz")
        }else if i%3 == 0{
          print("Fizz")
        }else if i%5 == 0{
          print("Buzz")
        }else{
          print(i)
        }
      }
      
    }
  }
  
  public func solution(_ S : inout String) -> String {
    // write your code in Swift 3.0 (Linux)
    
    var musicBytes = 0
    var imageBytes = 0
    var movieBytes = 0
    var othersBytes = 0

    let numOfLinesInString = S.components(separatedBy: "\n")
    
    for line in numOfLinesInString{
      let file = line.components(separatedBy: " ")
      if let fileName = file.first, let fileType = fileName.components(separatedBy: ".").last, var size = file.last {
          _ = size.remove(at: size.index(before: size.endIndex))
          if let fileSize = Int(size){
            
            switch fileType{
            case "mp3":
              fallthrough
            case "aac":
              fallthrough
            case "flac":
              musicBytes = musicBytes + fileSize
            case "jpg":
              fallthrough
            case "bmp":
              fallthrough
            case "gif":
              imageBytes = imageBytes + fileSize
            case "mp4":
              fallthrough
            case "avi":
              fallthrough
            case "mkv":
              movieBytes = movieBytes + fileSize
            default:
              othersBytes = othersBytes + fileSize
              break
            }
          }
      }
    }
    
    let returnString = "music " + "\(musicBytes)" + "b" + "\n" + "images " + "\(imageBytes)" + "b" + "\n" + "movies " + "\(movieBytes)" + "b" + "\n" + "other " + "\(othersBytes)" + "b"
    
    return returnString
  }

  
  
  func isBalanced(sequence: [String]) -> Bool {
    var stack = [String]()
    for bracket  in sequence {
      switch bracket {
      case "{", "[", "(":
        stack.append(bracket)
      case "}", "]", ")":
        if stack.isEmpty
          || (bracket == "}" && stack.last != "{")
          || (bracket == "]" && stack.last != "[")
          || (bracket == ")" && stack.last != "(")  {
          return false
        }
        stack.removeLast()
      default:
        fatalError("unknown bracket found")
      }
    }
    return stack.isEmpty
  }
  
  func mergeArrys(Array1: [Int], Array2:[Int]) -> [Int] {
    var mergedArray =  [Int]()
    
    var i = 0
    var j = 0
    var k = 0
    
    while(i < Array1.count && j < Array2.count){
      // Check if current element of first
      // array is smaller than current element
      // of second array. If yes, store first
      // array element and increment first array
      // index. Otherwise do same with second array
      if Array1[i] < Array2[j]{
        mergedArray.insert(Array1[i], at: k)
        i = i + 1
      }else{
        mergedArray.insert(Array2[j], at: k)
        j = j + 1
      }
      k = k + 1
    }
    
    // Store remaining elements of first array
    while (i < Array1.count) {
     mergedArray.insert(Array1[i], at: k)
       k = k + 1
      i = i + 1
    }
    
    // Store remaining elements of second array
    while (j < Array2.count) {
      mergedArray.insert(Array2[j], at: k)
      k = k + 1
      j = j + 1
    }
    
    return mergedArray
  }

  
  func checkArrayContainsString(){
    let string = "The rain in Spain"
    let stringResult = string.contains("rain")
    
    let words = ["clouds", "rain", "wind"]
    let arrayResult = words.contains("rain")
    
    let combinedResult = words.contains(where: string.contains)
    print(combinedResult)
  }
  @objc func AVModeChanged (_ notification:Notification) {
    print(notification.userInfo)
  }
  
  @IBAction func playPauseButton(_ sender: Any) {
    if !playerisPaused{
      player?.pause()
      playerisPaused = true
    }else{
      player?.play()
      playerisPaused = false
    }
    let hdrMode = AVPlayer.availableHDRModes
    let gravity = player?.externalPlaybackVideoGravity
    print(gravity)
    
    switch hdrMode {
    case .dolbyVision:
      print(hdrMode.rawValue)
    case .hlg:
      print(hdrMode.rawValue)
    case .hdr10:
      print(hdrMode.rawValue)
    default:
      break
    }
  }
  
  func personalizeCoupon(couponArray: [[String:Any]], categories: [String]){
    let preferredCoupons = couponArray.reduce(into: [[String:Any]]()) {
      if categories.contains($1["category"] as! String){
        $0.append($1)
      }
    }
    
    var sortedCoupons = preferredCoupons.sorted {
      if let item1Price = $0["itemPrice"] as? Double, let item2Price = $1["itemPrice"] as? Double{
        return item1Price > item2Price
      }
      return false
    }
    
    while sortedCoupons.count > 10{
      sortedCoupons.remove(at: 10)
    }
    
    var finalCoupons: [[String:Any]] = []
    for var coupon in sortedCoupons{
      if let coup = coupon.removeValue(forKey: "code") as? [String:Any] {
        finalCoupons.append(coup)
      }
    }
    
  }
  
  func customSortUsingSets(){
    let intArray = [10,8,5,5,5,5,1,1,1,4,4]
    var outputArray: [Int] = []
    var countArray: [Int] = []
    
    let setArray = NSCountedSet()
    for val in intArray{
      setArray.add(val)
    }
  
    let sortedSet = setArray.sorted {
      return setArray.count(for: $0) < setArray.count(for: $1)
    }
    
    for val in sortedSet{
      for _ in 0..<setArray.count(for: val){
        outputArray.append(val as! Int)
      }
    }
    
   print(outputArray)
    
    
  }
  func customSort() {
    var intArray = [10,8,5,5,5,5,1,1,1,4,4]
    var counter = 0
    var dict: [String: [Int]] = [:]
    var keyArray: [String] = []
    var outputArray: [Int] = []
    let setArray = Array(Set(intArray)).sorted()
    var currentInt = 0
    
    for i in 0..<setArray.count{
      for j in 0..<intArray.count{
        if setArray[i] == intArray[j]{
          counter = counter + 1
          currentInt = setArray[i]
        }
      }
      
      for _ in 0..<counter{
        if let valueArray = dict["\(counter)"]  {
          var newArray: [Int] = valueArray
          newArray.append(currentInt)
          dict["\(counter)"]  = newArray.sorted()
        }else{
          dict["\(counter)"]  = [currentInt]
        }
      }
      
      counter = 0
    }
    
    var sortedKeys:[Int] = []
    for (key, _) in dict{
      if let intValue = Int(key){
        sortedKeys.append(intValue)
      }
    }
    sortedKeys = sortedKeys.sorted()
    keyArray.removeAll()
    for key in sortedKeys{
      keyArray.append("\(key)")
    }
    
    
    
    for key in keyArray{
      if let values = dict[key]{
        outputArray = outputArray + values
      }
    }
    
    print(outputArray)
  }
  
//
//  func mixStrings() {
//    for i in 0..<a.count{
//      if i < b.count{
//        for j in i..<b.count{
//          counter = counter + 1
//          if let a_sub = a.substring(i), let b_sub = b.substring(j){
//            mixed = mixed + a_sub
//            mixed = mixed + b_sub
//          }
//          break
//        }
//      }
//    }
//
//    var newStr = ""
//    if counter < b.count{
//      let index = b.index(b.startIndex, offsetBy: counter)
//      newStr = String(b[index...])
//    }else if counter < a.count{
//      let index = a.index(a.startIndex, offsetBy: counter)
//      newStr = String(a[index...])
//    }
//    mixed = mixed + newStr
//    print(mixed)
//  }
  

  
}


extension String {
  func substring(_ from: Int) -> String? {
    for (index, c) in self.enumerated(){
      if index == from{
        return String(c)
      }
    }
    return nil
  }
}



public class SNode<T> {
  var value: T
  var next: SNode<T>?
  
  init(value: T) {
    self.value = value
  }
}


class SingleLinkedList<T> {
  
  var head: SNode<T>? // head is nil when list is empty
  
  public var isEmpty: Bool {
    return head == nil
  }
  
  public var first: SNode<T>? {
    return head
  }
  
  public func append(value: T) {
    let newNode = SNode(value: value)
    if var h = head {
      while h.next != nil {
        h = h.next!
      }
      h.next = newNode
      
    } else {
      head = newNode
    }
  }
  
  func insert(data : T, at position : Int) {
    let newNode = SNode(value: data)
    
    if (position == 0) {
      newNode.next = head
      head = newNode
    }
    else {
      var previous = head
      var current = head
      for _ in 0..<position {
        previous = current
        current = current?.next
      }
      
      newNode.next = previous?.next
      previous?.next = newNode
    }
  }
  
  func deleteNode(at position: Int)
  {
    if head == nil{
      return
    }
    var temp = head
    
    if (position == 0)
    {
      head = temp?.next
      return
    }
    
    for _ in 0..<position-1 where temp != nil {
      temp = temp?.next
    }
    
    if temp == nil || temp?.next == nil{
      return
    }
    
    let nextToNextNode = temp?.next?.next
    
    temp?.next = nextToNextNode
  }
  
  func printList() {
    var current: SNode? = head
    //assign the next instance
    while (current != nil) {
      print("LL item is: \(current?.value as? String ?? "")")
      current = current?.next
    }
  }
  
  
  func printReverseRecursive(node: SNode<T>?) {
    if node == nil{
      return
    }
    printReverseRecursive(node: node?.next)
    print("LL item is: \(node?.value as? String ?? "")")
  }
  
  func printReverse() {
    printReverseRecursive(node: first)
    
  }
}

// Fibonacci series
// F[n] = F[n-1] + F[n-2]
// 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144
// Find the fibonacci number for n interations
func fibonacci(n: Int) {
    
    var num1 = 0
    var num2 = 1
    
    for _ in 0 ..< n {
        
        let num = num1 + num2
        num1 = num2
        num2 = num
    }
    
    print("result = \(num2)")
}

// Using Recursion
func fibonacciRecursiveNum1(num1: Int, num2: Int, steps: Int) {
    
    if steps > 0 {
        let newNum = num1 + num2
        fibonacciRecursiveNum1(num1: num2, num2: newNum, steps: steps-1)
    }
    else {
        print("result = \(num2)")
    }
}

