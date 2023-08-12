//
//  PatchCategory.swift
//  
//
//  Created by Ludovic HENRY on 11/08/2023.
//

import Foundation

struct PatchCategory: Codable {
    let id: UUID
    let name: String?
    let type: CategoryType?
}
