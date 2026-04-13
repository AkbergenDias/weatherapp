//
//  NetworkService.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
}

class NetworkService: NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
