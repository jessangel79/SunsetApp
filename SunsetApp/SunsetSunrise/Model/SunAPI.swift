//
//  SunAPI.swift
//  SunsetApp
//
//  Created by Angelique Babin on 30/09/2020.
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sunAPI = try? newJSONDecoder().decode(SunAPI.self, from: jsonData)

import Foundation

// MARK: - SunAPI
struct SunAPI: Decodable {
    let results: ResultsApi
    let status: String
}

// MARK: - Results
struct ResultsApi: Decodable {
    let sunrise, sunset: String
    let dayLength: Int

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
        case dayLength = "day_length"
    }
}
