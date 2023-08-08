//
//  PatchExpense.swift
//  
//
//  Created by Ludovic HENRY on 08/08/2023.
//

import Foundation

struct PatchExpense: Codable {
    let id: UUID
    let categoryID: UUID?
    let accountID: UUID?
    let description: String?
    let amount: Int?
    let date: Date?
}
