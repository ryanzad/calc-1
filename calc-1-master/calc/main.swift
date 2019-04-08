//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var nums: [Int64] = []
var ops: [String] = []
var result: Int64 = 0
var stderr = FileHandle.standardError
let stdout = FileHandle.standardOutput

// function to calculate actual operation between 2 numbers
func calculate(num1: Int64, op: String, num2: Int64) -> Int64 {
    switch op {
    case "+":
        return num1 + num2
    case "-":
        return num1 - num2
    case "x":
        return num1 * num2
    case "/":
        if(num2 == 0){
            writeError(s: "invalid input")
        }
        return num1 / num2
    case "%":
        return num1 % num2
    default:
        writeError(s: "invalid input")
        return 0;
    }
}

// function to decide which operator to evaluate first between 2 operators
func shouldSecondEvaluatedFirst(first: String, second: String) -> Bool{
    if(first == second){
        return false;
    }
    let orderOfOperations = ["x","/","%"]
    if(orderOfOperations.contains(first) && orderOfOperations.contains(second)){
        var i1 = 0;
        var i2 = 0;
        for i in 0...orderOfOperations.count-1{
            if(orderOfOperations[i] ==  first){
                i1 = i
            }else if(orderOfOperations[i] ==  second){
                i2 = i
            }
        }
        return i1 > i2
    }else if(orderOfOperations.contains(first) && !orderOfOperations.contains(second)){
        return false;
    }else if(!orderOfOperations.contains(first) && orderOfOperations.contains(second)){
        return true;
    }else{
        return false;
    }
}

//function to perform operations
func performOperations(){
    let i:Int = 0
    while i < ops.count-1 {
        if(i < ops.count && shouldSecondEvaluatedFirst(first: ops[i], second: ops[i+1])){
            executeOneOperator(i: i+1)
        }else{
            executeOneOperator(i: i)
        }
    }
    result = calculate(num1: nums[0], op: ops[0], num2: nums[1])
}

//function to execute one operation
func executeOneOperator(i: Int){
    result = calculate(num1: nums[i], op: ops[i], num2: nums[i+1])
    ops.remove(at: i)
    nums.remove(at: i+1)
    nums[i] = result;
    performOperations();
}

//function to convert string to Int64
func convertStringToInt(s: String) -> Int64 {
    if let number = Int64(s as String) {
        return number
    }
    writeError(s: "invalid input")
    return -1
}

//function to separate args into numbers and operators and store into arrays
func storeArgs(args: Array<String>){
    var numNext = true;
    if(args.count == 1){
        result = convertStringToInt(s: args[0])
        writeSuccess(s: String(result))
    } else if(args.count >= 3){
        for input in args {
            if(numNext){
                nums.append(convertStringToInt(s: input))
                numNext = false;
            }else{
                ops.append(input)
                numNext = true;
            }
        }
    }else{
        writeError(s: "invalid input")
    }
}

//function to validate input
func validateInput(){
    if(nums.count != ops.count+1){
        writeError(s: "invalid input")
    }
}

//function to write error and exit program
func writeError(s: String){
    if let data = (s + "\n").data(using: String.Encoding.utf8) {
        stderr.write(data)
        exit(EXIT_FAILURE)
        
    }
}

//function to write success and exit program
func writeSuccess(s: String){
    if let data = (s + "\n").data(using: String.Encoding.utf8) {
        stdout.write(data)
        exit(EXIT_SUCCESS)
    }
}

//controller function
func main() {
    var args = ProcessInfo.processInfo.arguments
    args.removeFirst()
    storeArgs(args: args);
    validateInput();
    performOperations();
    writeSuccess(s: String(result))
}
main()
