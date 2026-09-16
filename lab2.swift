let fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
print(fruits[2]) 


var favoriteNumbers: Set = [7, 14, 21, 28]
favoriteNumbers.insert(42)
print(favoriteNumbers)

let languages = ["Python": 1991, "Swift": 2014, "Java": 1995]
print(languages["Swift"]!)

var colors = ["Red", "Green", "Blue", "Yellow"]
colors[1] = "Purple" 
print(colors)

//Medium Tasks

let set1: Set = [1, 2, 3, 4]
let set2: Set = [3, 4, 5, 6]
let intersectionResult = set1.intersection(set2)
print(intersectionResult)

var studentScores = ["Alice": 85, "Bob": 90, "Charlie": 78]
studentScores["Alice"] = 92 
print(studentScores)

let array1 = ["apple", "banana"]
let array2 = ["cherry", "date"]
let mergedArray = array1 + array2
print(mergedArray)

//Hard Tasks
var populations = ["Japan": 125000000, "Germany": 83000000]
populations["Canada"] = 38000000
print(populations)


let setA: Set = ["cat", "dog"]
let setB: Set = ["dog", "mouse"]
let unionSet = setA.union(setB)
let finalSet = unionSet.subtracting(setB)
print(finalSet)


let studentGrades = [
    "Alice": [85, 90, 95],
    "Bob": [70, 75, 80]
]
print(studentGrades["Alice"]![1])