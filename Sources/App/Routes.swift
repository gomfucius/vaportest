import Vapor
import Foundation

extension Droplet {
    func setupRoutes() throws {
        get("/") { req in
            let date = Date()
            let calendar = Calendar.current
            let second = calendar.component(.second, from: date)
            let testModel = TestModel(email: "\(second)@example.com")
            try testModel.save()
            return req.description
        }

        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
