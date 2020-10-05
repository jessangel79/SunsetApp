//
//  SunNoFormattedAPI.swift
//  SunsetApp
//
//  Created by Angelique Babin on 30/09/2020.
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sunNoFormattedAPI = try? newJSONDecoder().decode(SunNoFormattedAPI.self, from: jsonData)

import Foundation

// MARK: - SunNoFormattedAPI
struct SunNoFormattedAPI: Decodable {
    let results: ResultsNoFormattedApi
    let status: String
}

// MARK: - Results
struct ResultsNoFormattedApi: Decodable {
    let sunrise, sunset: String
    let dayLength: Int

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
        case dayLength = "day_length"
    }
}
