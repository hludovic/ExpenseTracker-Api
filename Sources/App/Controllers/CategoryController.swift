//
//  CategoryController.swift
//  
//
//  Created by Ludovic HENRY on 29/07/2023.
//

import Fluent
import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categories")
        categories.get(use: index)
        categories.post(use: create)
        categories.patch(use: update)
        categories.put(":categoryID", use: archive)
    }

    func index(req: Request) async throws -> [Category] {
        try await Category.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Category {
        let catrgory = try req.content.decode(Category.self)
        try await catrgory.save(on: req.db)
        return catrgory
    }

    func archive(req: Request) async throws -> HTTPStatus {
        guard let categoryID = req.parameters.get("categoryID") else {
            throw Abort(.badRequest)
        }
        guard let category = try await Category.find(UUID(uuidString: categoryID), on: req.db) else {
            throw Abort(.notFound)
        }
        category.isArchived = true
        try await category.update(on: req.db)
        return .ok
    }

    func update(req: Request) async throws -> Category {
        let patchCategory = try req.content.decode(PatchCategory.self)
        guard let categoryFromDB = try await Category.find(patchCategory.id, on: req.db) else {
            throw Abort(.notFound)
        }
        if let name = patchCategory.name {
            categoryFromDB.name = name
        }
        if let type = patchCategory.type {
            categoryFromDB.type = type
        }
        try await categoryFromDB.update(on: req.db)
        return categoryFromDB
    }
}
