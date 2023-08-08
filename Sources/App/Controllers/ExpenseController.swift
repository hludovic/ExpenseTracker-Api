//
//  ExpenseController.swift
//  
//
//  Created by Ludovic HENRY on 30/07/2023.
//

import Fluent
import Vapor

struct ExpenseController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let expenses = routes.grouped("expenses")
        expenses.get(use: index)
        expenses.post(use: create)
        expenses.put(use: update)
        expenses.delete(":expenseID", use: delete)
    }

    func index(req: Request) async throws -> [Expense] {
        try await Expense.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Expense {
        let expense = try req.content.decode(Expense.self)
        try await expense.save(on: req.db)
        return expense
    }

    func update(req: Request) async throws -> HTTPStatus {
        let expense = try req.content.decode(Expense.self)
        guard let expenseFromDB = try await Expense.find(expense.id, on: req.db) else {
            throw Abort(.notFound)
        }
        expenseFromDB.$account.id = expense.$account.id
        expenseFromDB.description = expense.description
        expenseFromDB.amount = expense.amount
        expenseFromDB.currency = expense.currency
        expenseFromDB.date = expense.date
        try await expenseFromDB.update(on: req.db)
        return .ok
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let expenseID = req.parameters.get("expenseID") else {
            throw Abort(.badRequest)
        }
        guard let expense = try await Expense.find(UUID(uuidString: expenseID), on: req.db) else {
            throw Abort(.notFound)
        }
        try await expense.delete(on: req.db)
        return .noContent
    }
}
