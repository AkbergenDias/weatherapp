//
//  NetworkServiceProtocol.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL) async throws -> T
}
