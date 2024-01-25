import Foundation

// Inspired by: https://www.avanderlee.com/swift/reflection-how-mirror-works/

public struct Comparator {

    private init() {}
    
    public static func compare(_ one: Any, _ two: Any) -> Bool {

        // Custom type comparations
        if let dictionaryOne = one as? NSDictionary, let dictionaryTwo = two as? NSDictionary {
            return compareDictionaries(dictionaryOne, dictionaryTwo)
        }

        if let setOne = one as? NSSet, let setTwo = two as? NSSet {
            return compareSet(setOne, setTwo)
        }

        // Compare by Mirroring
        let mirrorOne = Mirror(reflecting: one)
        let mirrorTwo = Mirror(reflecting: two)

        guard mirrorOne.subjectType == mirrorTwo.subjectType else {
            return false
        }
        guard mirrorOne.children.count == mirrorTwo.children.count else {
            return false
        }

        let iteratorOne = mirrorOne.children.makeIterator()
        let iteratorTwo = mirrorTwo.children.makeIterator()

        if mirrorOne.children.count > 0 {

            var idx = 0
            while idx < mirrorOne.children.count {
                if let childOne = iteratorOne.next(), let childTwo = iteratorTwo.next() {
                    if let labelOne = childOne.label, let labelTwo = childTwo.label {
                        if labelOne == labelTwo {
                            guard Self.compare(childOne.value, childTwo.value) else {
                                return false
                            }
                        } else {
                            return false
                        }
                    } else if childOne.label == nil && childTwo.label == nil {
                        guard Self.compare(childOne.value, childTwo.value) else {
                            return false
                        }
                    } else {
                        return false
                    }
                } else {
                    return false
                }
                idx += 1
            }
            return true
        } else {
            if let compOne: any Hashable = one as? (any Hashable), let compTwo: any Hashable = two as? (any Hashable) {
                let result = compOne.hashValue == compTwo.hashValue
//                print("\(result) \(compOne) \(compTwo) \(compOne.hashValue) \(compTwo.hashValue)")
                return result
            } else {
                let result = "\(one)" == "\(two)"
//                print("\(result) \(one) \(two)")
                return result
            }
        }
    }

    private static func compareDictionaries(_ dict1: NSDictionary, _ dict2: NSDictionary) -> Bool {

        guard dict1.allKeys.count == dict2.allKeys.count else {
            return false
        }

        var array1: [Any] = []
        var array2: [Any] = []
        for key in dict1.allKeys {
            if let obj1 = dict1.object(forKey: key), let obj2 = dict2.object(forKey: key) {
                array1.append(obj1)
                array2.append(obj2)
            } else {
                return false
            }
        }
        return Self.compare(array1, array2)
    }

    private static func compareSet(_ set1: NSSet, _ set2: NSSet) -> Bool {

        guard set1.count == set2.count else {
            return false
        }

        for obj1 in set1.allObjects {
            var found = false
            for obj2 in set2.allObjects {
                if Self.compare(obj1, obj2) {
                    found = true
                }
            }

            if !found {
                return false
            }
        }
        return true
    }
}
