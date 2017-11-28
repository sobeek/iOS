//: Playground - noun: a place where people can play

import UIKit

/*var str = "Hello, playground"

let y = "My"
print (str)
class MyClass {
    var temp: Int
    init() {
        temp = 42
    }
}

var a = MyClass()
print (a.temp)
*/

/* class Color {
    var red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)

print (halfGray.blue, halfGray.green)

// halfGray.blue = 0.1

class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
        if (response != nil) {print(response!)}
    }
    
    func resp() {
    }
}
let cheeseQuestion = SurveyQuestion(text: "Нравится ли вам сыр?")
cheeseQuestion.ask()
// Выведет "Нравится ли вам сыр?"

cheeseQuestion.response = "DA"
cheeseQuestion.resp()

class FourWheel {
    
    var wheelDiametr: Int = 14
    var season = "Winter"
    
    //init(wheelDiametr: Int){
    //    self.wheelDiametr = wheelDiametr
    // }
    
    func changeWheel() {
        season = "Summer"
    }
}

let fw1 = FourWheel() */

// Develop a program which solves the following task: Find one of the numbers which exists in each of three nondecreasing arrays x[p], y[q], z[r]. Algorithm complexity should be O(p+q+r).
/*
let x = [-1,0]
let y = [-2,-1, 109, 1000]
let z = [-1,0,5,8,11,14,17,1000]


func minimum(_ a: Int, _ b: Int) -> Int {
    return a < b ? a : b
}

func maximum (_ a: Int, _ b: Int) -> Int {
    return a < b ? b : a
}



//let min_array_index = minimum(x.count, minimum(y.count, z.count))

func minimal_intersection (_ x: [Int], _ y:[Int], _ z: [Int]) -> Int! {
    
    //print(x)
    
    var p = 0
    var q = 0
    var r = 0

    let x_count = x.count
    let y_count = y.count
    let z_count = z.count
    
    while (p < x_count && q < y_count && r < z_count) {
        // print(1)
        // print (x[p], y[q], z[r])
        //print (y[q])
        //print (z[r])
        let min = minimum(x[p], minimum(y[q], z[r]))
        let max = maximum(x[p], maximum(y[q], z[r]))
    
        if (min == max) {return min}
        
        switch min {
            case x[p]:
                p+=1
            case y[q]:
                q+=1
            default:
                r+=1
        }
        
        //candidate = min
    }

    return nil
}


minimal_intersection(x, y, z)

var a = 8
var b = 9

func my_swap (_ a: inout Int, _ b: inout Int) {
    a = -a - b
    b = -a - b
    a = -a - b
    
    a
    b
}

my_swap(&a, &b)

func fast_power (_ a: Double, _ n: Int) -> Double {
    
    if n==0 {return 1}
    
    if (n % 2 == 0) {
        // print(n)
        return fast_power(a, n/2)*fast_power(a, n/2)
    } else {
        // print(n)
        return fast_power(a, n-1)*a
    }
}

fast_power(1+sqrt(3), 1)


let pair_1 = [2,5]
let pair_2 = [3,5]
let pair_3 = [5,8]
let pair_4 = [0, 100]
let pair_5 = [9,112]
let pair_6 = [6,7]

let pairs = [pair_1, pair_2, pair_3, pair_4, pair_5, pair_6]

//var arrive = pairs.sorted(by: {$0[0] < $1[0]})
var arrive = pairs.map{$0[0]}.sorted()
var depart = pairs.map{$0[1]}.sorted()

//arrive = arrive.flatMap { $0 }
arrive
depart

var persons = 0
var p = 0
var q = 0
var max = 0

func compare <T: Comparable> (_ a: T, _ b: T) -> Int {
    if a == b {return 0}
    return a < b ? -1 : 1
}

while p < arrive.count && q < depart.count {
    // print (1)
    
    switch compare(arrive[p], depart[q]) {
        
    case -1:
        persons += 1
        p+=1
        
    case 0:
        p += 1
        q += 1
        
    case 1:
        persons -= 1
        q+=1
        
    default:
        break
    }
    max = persons > max ? persons : max
    
}
max


class Node<T> {
    var node: T
    var name: String
    var children: [Node] = []
    var parent: Node?
    var max = 0
    
    init(_ node: T, _ name: String) {
        self.node = node
        self.name = name
    }
    
    func insert_node(child: [Node]) {
        children += child
        for ch in child {
            ch.parent = self
        }
    }
    
}

//let new_node = Node(node: 3)
//print (new_node.node)

let beverages = Node(0, "beverages")

let hot = Node(-1, "hot")
let cold = Node(1, "cold")
    
//let childs =

beverages.insert_node(child: [hot, cold])
//print (beverages.children.node)
for child in beverages.children {
    print (child.node)
}

let tea = Node(-2, "tea")
let coffee = Node(-3, "coffee")
let cocoa = Node(-4, "cocoa")

hot.insert_node(child: [tea, coffee, cocoa])

let black = Node(-5, "black")
let green = Node(-6, "green")

tea.insert_node(child: [black, green])

let soda = Node(2, "soda")
let milk = Node(3, "milk")

cold.insert_node(child: [soda, milk])

let ale = Node(4, "ale")
let lemon = Node(5, "lemon")

soda.insert_node(child: [ale, lemon])

extension Node where T: Equatable {
    func search(_ value: T) -> Node? {
        if value == self.node {
            return self
        }
        
        for child in children {
            let found = child.search(value)
            if found != nil {
                return found
            }
        }
        return nil
        
    }
}

milk.search(3)?.parent?.name

let string = Node("aaa", "aaa")

extension Node {
    func max_depth() -> Int {
        var depth = 0
        if(!self.children.isEmpty) {
            for child in self.children {
                depth = child.max_depth() + 1
                // print ("depth = \(depth)")
                max = depth > max ? depth : max
            }
        }
        return max
    }
}

print(beverages.max_depth())


class linked {
    var value: Int
    var next: linked!
    
    init(_ value: Int, _ next: linked!) {
        self.value = value
        self.next = next
    }
}

func reverse(_ list: [linked]) -> [linked] {
    let count = list.count
    // print (count)
    
    var linked_reversed = [linked]()
    let last_index = count - 1
    
    for index in 0...last_index {
        let new_obj = linked(list[last_index - index].value, nil)
        //print (new_obj.next)
        
        if (last_index > index) {
            new_obj.next = list[last_index - 1 - index]
            
        }
        
        linked_reversed.append(new_obj)
    }
    return linked_reversed
}

var d = linked(4, nil)
var c = linked(3, d)
var b1 = linked(2, c)
var a1 = linked(1, b1)

var linkedList = [a1,b1,c,d]

for index in linkedList {
    print ("\(index.value) -> \(index.next?.value)")
}

//let reversed: [linked]

//reversed = linkedList.reversed()
//print(reversed)

let linked_reversed = reverse(linkedList)

for member in linked_reversed {
    if member.next != nil {
        print ("\(member.value) -> \(member.next!.value)" )
    }
    else {
        print ("\(member.value) -> nil" )
    }
    //if c != nil {c = c!.value}
    // print ("\(member.value) -> \(c)")
}

var countingUp = ["one", "two", "three"]
let range = countingUp.count

for (i, str) in countingUp.enumerated() {
    print (i * i, str)
} */







