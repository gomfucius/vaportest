import Vapor
import FluentProvider
import HTTP

final class TestModel: Model, NodeConvertible {

    struct Properties {
        static let email = "email"
        static let accessCount = "access_count"
    }

    let storage = Storage()
    var email: String
    var accessCount: Int

    init(email: String) {
        self.email = email
        self.accessCount = 0
    }

    // MARK: - Entity

    func willUpdate() throws {
        accessCount += 1
    }

    // MARK: Row

    /// Initializes the User from the
    /// database row
    init(row: Row) throws {
        email = try row.get(TestModel.Properties.email)
        accessCount = try row.get(TestModel.Properties.accessCount)
    }

    // MARK: RowRepresentable

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(TestModel.Properties.email, email)
        try row.set(TestModel.Properties.accessCount, accessCount)
        return row
    }

    // MARK: NodeInitializable

    init(node: Node) throws {
        self.email = try node.get(TestModel.Properties.email)
        self.accessCount = try node.get(TestModel.Properties.accessCount)
    }

    // MARK: NodeRepresentable

    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set(TestModel.Properties.email, email)
        try node.set(TestModel.Properties.accessCount, accessCount)
        return node
    }
}

// MARK: Preparation

extension TestModel: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Users
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(TestModel.Properties.email)
            builder.int(TestModel.Properties.accessCount)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension TestModel: Timestampable {}
