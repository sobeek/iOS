//: Playground - noun: a place where people can play

import UIKit

let numberFomatter = NumberFormatter()

numberFomatter.numberStyle = .decimal
numberFomatter.minimumFractionDigits = 0
numberFomatter.maximumFractionDigits = 2
numberFomatter.roundingMode = .down

let string = numberFomatter.string(from: 3.14959)