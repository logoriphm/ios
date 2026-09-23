// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each signature when you start working on it.


// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":") else {
        return nil
    }

    let sensor = parts.0
    let rawValue = parts.1

    guard !sensor.isEmpty else {
        return nil
    }

    guard !rawValue.isEmpty else {
        return nil
    }

    guard let value = Int(rawValue) else {
        return nil
    }

    return (sensor: sensor, value: value)
}

// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0

    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }

    return (valid: valid, invalidCount: invalidCount)
}

let parsedLog = parseLog(rawLog)
let A = "valid:\(parsedLog.valid.count),invalid:\(parsedLog.invalidCount)"

print("A = \(A)")


// MARK: Level 2 · Analysis

// 2.1
func select(
    _ readings: [Reading],
    where isIncluded: (Reading) -> Bool
) -> [Reading] {
    var result: [Reading] = []

    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }

    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []

    for reading in readings {
        result.append(reading.value)
    }

    return result
}

// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard !values.isEmpty else {
        return nil
    }

    var minValue = values[0]
    var maxValue = values[0]
    var total = 0

    for value in values {
        if value < minValue {
            minValue = value
        }

        if value > maxValue {
            maxValue = value
        }

        total += value
    }

    let average = Double(total) / Double(values.count)

    return (
        min: minValue,
        max: maxValue,
        average: average
    )
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    return stats(of: values)
}

let oxygenReadings = select(parsedLog.valid) { reading in
    reading.sensor == "O2"
}

let oxygenValues = values(of: oxygenReadings)

let oxygenStats = stats(of: oxygenValues)

var B = "no-data"

if let oxygenStats = oxygenStats {
    B = "min:\(oxygenStats.min),max:\(oxygenStats.max),avg:\(String(format: "%.2f", oxygenStats.average))"
}

print("B = \(B)")


// 2.3 · The Closure Ladder
// 5 sorts, then compare results in code

let readingsForSorting = parsedLog.valid

// 1. Full closure syntax
let sort1 = readingsForSorting.sorted(by: {
    (left: Reading, right: Reading) -> Bool in
    return left.value < right.value
})

// 2. Type inference
let sort2 = readingsForSorting.sorted(by: {
    left, right in
    left.value > right.value
})

// 3. Shorthand arguments
let sort3 = readingsForSorting.sorted {
    $0.sensor < $1.sensor
}

// 4. Multiple conditions
let sort4 = readingsForSorting.sorted {
    if $0.sensor == $1.sensor {
        return $0.value < $1.value
    }

    return $0.sensor < $1.sensor
}

// 5. Trailing closure with descending sensor/value
let sort5 = readingsForSorting.sorted {
    if $0.sensor == $1.sensor {
        return $0.value > $1.value
    }

    return $0.sensor > $1.sensor
}

print("Sort 1: \(sort1)")
print("Sort 2: \(sort2)")
print("Sort 3: \(sort3)")
print("Sort 4: \(sort4)")
print("Sort 5: \(sort5)")

let sameSort1And2 = sort1.count == sort2.count

var sameValues = true

if sort1.count == sort2.count {
    var i = 0

    while i < sort1.count {
        if sort1[i].value != sort2[sort2.count - 1 - i].value {
            sameValues = false
            break
        }

        i += 1
    }
} else {
    sameValues = false
}

print("Sort 1 and Sort 2 contain the same values in reverse order: \(sameSort1And2 && sameValues)")


// MARK: Level 3 · Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int {
    return t + 5
}

func coolDown(_ t: Int) -> Int {
    return t - 5
}

func hold(_ t: Int) -> Int {
    return t
}

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    }

    if temp > 22 {
        return coolDown
    }

    return hold
}

// 3.2
func runUntilStable(
    from start: Int,
    maxSteps: Int = 10
) -> (finalTemp: Int, steps: Int, isStable: Bool) {

    var temperature = start
    var steps = 0

    while steps < maxSteps {
        if temperature >= 18 && temperature <= 22 {
            return (
                finalTemp: temperature,
                steps: steps,
                isStable: true
            )
        }

        let protocolFunction = chooseProtocol(for: temperature)
        let nextTemperature = protocolFunction(temperature)

        temperature = nextTemperature
        steps += 1
    }

    let stable = temperature >= 18 && temperature <= 22

    return (
        finalTemp: temperature,
        steps: steps,
        isStable: stable
    )
}

let CResult = runUntilStable(from: -12)

let C = "temp:\(CResult.finalTemp),steps:\(CResult.steps),stable:\(CResult.isStable)"

print("C = \(C)")


// MARK: Level 4 · The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? {
    guard let module = member.module else {
        return nil
    }

    guard let tank = module.oxygenTank else {
        return nil
    }

    return tank.level
}

// 4.2
func status(of member: CrewMember) -> String {
    guard let module = member.module else {
        return "\(member.name): open space"
    }

    guard let oxygen = oxygenLevel(of: member) else {
        return "\(member.name): \(module.name), no oxygen tank"
    }

    return "\(member.name): \(module.name), oxygen \(oxygen)%"
}

// 4.3
@discardableResult
func transferOxygen(
    from source: inout Int,
    to target: inout Int,
    amount: Int
) -> Int {

    guard amount > 0 else {
        return 0
    }

    let transferred = min(source, amount)

    source -= transferred
    target += transferred

    return transferred
}

var labOxygen = 40
var habOxygen = 12

let transferred = transferOxygen(
    from: &labOxygen,
    to: &habOxygen,
    amount: 10
)

print("Transferred oxygen: \(transferred)%")
print("Lab oxygen: \(labOxygen)%")
print("Hab oxygen: \(habOxygen)%")

// 4.4
func evacuationOrder(
    _ names: String...,
    roster: [String: CrewMember]
) -> [String] {

    var members: [CrewMember] = []

    for name in names {
        if let member = roster[name] {
            members.append(member)
        }
    }

    members.sort {
        $0.priority < $1.priority
    }

    var result: [String] = []

    for member in members {
        result.append(member.name)
    }

    return result
}

let DOrder = evacuationOrder(
    "Timur",
    "Dana",
    "Aigerim",
    "Nurlan",
    roster: roster
)

let D = DOrder.joined(separator: ">")

print("D = \(D)")


// MARK: Level 5 · The Saboteur's Logbook
// Problems:
// 1. Force unwrap of module.
// 2. Force unwrap of oxygenTank.
// 3. Force unwrap of optional oxygenLevel.
// 4. firstCritical returns the last critical member.
// 5. result! can crash when there is no critical member.


// Fixed version of reportOxygen

func reportOxygen(for member: CrewMember) -> String {
    guard let oxygen = oxygenLevel(of: member) else {
        return "\(member.name): no oxygen data"
    }

    return "\(member.name): \(oxygen)%"
}


// Fixed version of firstCritical

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let oxygen = oxygenLevel(of: member) else {
            continue
        }

        if oxygen < 20 {
            return member.name
        }
    }

    return nil
}


// Test proving the logic bug is fixed

let criticalCrew = [
    CrewMember(
        name: "FirstCritical",
        role: "Engineer",
        priority: 1,
        module: Module(
            name: "Critical-1",
            oxygenTank: Tank(level: 10)
        )
    ),
    CrewMember(
        name: "SecondCritical",
        role: "Scientist",
        priority: 2,
        module: Module(
            name: "Critical-2",
            oxygenTank: Tank(level: 5)
        )
    )
]

let criticalResult = firstCritical(in: criticalCrew)

print("First critical crew member: \(criticalResult ?? "none")")

if criticalResult == "FirstCritical" {
    print("Logic bug fixed: first critical member is returned.")
} else {
    print("Logic bug still exists.")
}

print(reportOxygen(for: crew[0]))
print(reportOxygen(for: crew[1]))
print(reportOxygen(for: crew[2]))
print(reportOxygen(for: crew[3]))


// MARK: Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var alarmCount = 0

    return { value in
        alarmCount += 1

        return value < threshold
    }
}

let alarm = makeAlarm(threshold: 20)

print("Alarm 1: \(alarm(25))")
print("Alarm 2: \(alarm(15))")
print("Alarm 3: \(alarm(10))")
