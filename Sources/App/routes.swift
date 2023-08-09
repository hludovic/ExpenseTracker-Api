import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        sleep(1)
        return "Hello, world!"
    }

    try app.register(collection: AccountController())
    try app.register(collection: CategoryController())
    try app.register(collection: ExpenseController())
    try app.register(collection: IncomeController())
}
