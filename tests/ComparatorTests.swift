import XCTest
import Comparator

class ComparatorTests: XCTestCase {

    func testCompare() {

        XCTAssertTrue(Comparator.compare(TestEnum.plainCase, TestEnum.plainCase))
        XCTAssertTrue(Comparator.compare(TestEnum.associatedValueCase(99), TestEnum.associatedValueCase(99)))
        XCTAssertFalse(Comparator.compare(TestEnum.recursive(TestEnum.plainCase), TestEnum.recursive(TestEnum.associatedValueCase(0))))
        XCTAssertTrue(Comparator.compare(TestEnum.recursive(TestEnum.associatedValueCase(0)), TestEnum.recursive(TestEnum.associatedValueCase(0))))

        XCTAssertFalse(Comparator.compare(Date(timeIntervalSince1970: 2), Date(timeIntervalSince1970: 1)))
        XCTAssertTrue(Comparator.compare(Date(timeIntervalSince1970: 2), Date(timeIntervalSince1970: 2)))
        XCTAssertTrue(Comparator.compare("hello", "hello"))
        XCTAssertFalse(Comparator.compare("HELLO", "hello"))
        XCTAssertTrue(Comparator.compare(
            User(name: "pepito", permissions: [.dev, .legal, .basic("test"), .recursive(.admin("123", 64))], date: Date(timeIntervalSince1970: 1)),
            User(name: "pepito", permissions: [.dev, .legal, .basic("test"), .recursive(.admin("123", 64))], date: Date(timeIntervalSince1970: 1))
        ))
        XCTAssertFalse(Comparator.compare(
            User(name: "pepito", permissions: [.dev, .legal, .basic("test"), .recursive(.admin("123", 64))], date: Date(timeIntervalSince1970: 1)),
            User(name: "pepito", permissions: [.dev, .legal, .basic("test"), .recursive(.admin("321", 64))], date: Date(timeIntervalSince1970: 1))
        ))
        XCTAssertTrue(Comparator.compare(
            User(name: "pepito", permissions: [.sameAs(User(name: "new", permissions: [.recursive(.admin("123", 64))], date: Date(timeIntervalSince1970: 10)))], date: Date(timeIntervalSince1970: 13)),
            User(name: "pepito", permissions: [.sameAs(User(name: "new", permissions: [.recursive(.admin("123", 64))], date: Date(timeIntervalSince1970: 10)))], date: Date(timeIntervalSince1970: 13))
        ))
        XCTAssertFalse(Comparator.compare(
            User(name: "pepito", permissions: [.sameAs(User(name: "new", permissions: [.recursive(.admin("123", 64))], date: Date(timeIntervalSince1970: 10)))], date: Date(timeIntervalSince1970: 13)),
            User(name: "pepito", permissions: [.sameAs(User(name: "new", permissions: [.recursive(.admin("321", 64))], date: Date(timeIntervalSince1970: 10)))], date: Date(timeIntervalSince1970: 13))
        ))

        XCTAssertTrue(Comparator.compare([1, 2, 3], [1, 2, 3]))
        XCTAssertFalse(Comparator.compare([1, 2, 3], [1, 2, 2]))

        var setA = Set<String>()
        setA.insert("0")
        setA.insert("1")
        setA.insert("2")
        var setB = Set<String>()
        setB.insert("0")
        setB.insert("2")
        setB.insert("1")

        XCTAssertTrue(Comparator.compare(setA, setB))
        XCTAssertTrue(Comparator.compare(["key1": "value1", "key2": "value2"], ["key2": "value2", "key1": "value1"]))
        XCTAssertFalse(Comparator.compare(["key1": "value1", "key2": "value2"], ["key1": "value1", "key3": "value3"]))
    }

    class User {
        let name: String
        let permissions: [Permission]
        let date: Date

        init(name: String, permissions: [Permission], date: Date) {
            self.name = name
            self.permissions = permissions
            self.date = date
        }

        indirect enum Permission {
            case admin(String, Int)
            case dev
            case legal
            case basic(String)
            case recursive(Permission)
            case sameAs(User)
        }
    }

    indirect enum TestEnum {
        case plainCase
        case associatedValueCase(Int)
        case recursive(TestEnum)
    }
}
