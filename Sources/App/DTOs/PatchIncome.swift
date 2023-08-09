//
//  PatchIncome.swift
//  
//
//  Created by Ludovic HENRY on 09/08/2023.
//

import Foundation

struct PatchIncome: Codable {
    let id: UUID
    let categoryID: UUID?
    let amount: Int?
    let invoiceNumber: String?
    let invoiceDate: Date?
    let datePaid: Date?
    let description: String?
    let accountID: UUID?
}
