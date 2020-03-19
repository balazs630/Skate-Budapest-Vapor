//
//  PlaceRepository.swift
//  SkateBudapestBackend
//
//  Created by Horváth Balázs on 2018. 11. 26..
//

import Vapor
import FluentPostgreSQL

final class PlaceRepository {
    private let database: PostgreSQLDatabase.ConnectionPool

    init(_ database: PostgreSQLDatabase.ConnectionPool) {
        self.database = database
    }
}

// MARK: PlaceRepositoryInterface conformances
extension PlaceRepository: PlaceRepositoryInterface {
    func findAllPlacesWithImages(status: PlaceStatus) -> Future<([Place], [PlaceImage])> {
        return database.withConnection { conn in
            let places = Place.query(on: conn)
                .filter(\.status, .like, status)
                .all()

            let images = PlaceImage.query(on: conn)
                .all()

            return places.and(images)
        }
    }

    func findPlaceDataVersion() -> Future<PlaceDataVersion?> {
        return database.withConnection { conn in
            PlaceDataVersion.query(on: conn)
                .first()
        }
    }

    func findPlaceSuggestions(status: PlaceSuggestionStatus) -> Future<[PlaceSuggestion]> {
        return database.withConnection { conn in
            PlaceSuggestion.query(on: conn)
                .filter(\.status, .like, status)
                .all()
        }
    }

    func savePlaceSuggestion(suggestion: PlaceSuggestion) -> Future<PlaceSuggestion> {
        return database.withConnection { conn in
            PlaceSuggestion.query(on: conn)
                .create(suggestion)
        }
    }

    func clearPlaceSuggestions() -> EventLoopFuture<Void> {
        return database.withConnection { conn in
            PlaceSuggestion.query(on: conn)
                .update(\.status, to: .deleted)
                .run()
        }
    }

    func findPlaceReports(status: PlaceReportStatus) -> Future<[PlaceReport]> {
        return database.withConnection { conn in
            PlaceReport.query(on: conn)
                .filter(\.status, .like, status)
                .all()
        }
    }

    func savePlaceReport(report: PlaceReport) -> Future<PlaceReport> {
        return database.withConnection { conn in
            PlaceReport.query(on: conn)
                .create(report)
        }
    }

    func clearPlaceReports() -> EventLoopFuture<Void> {
        return database.withConnection { conn in
            PlaceReport.query(on: conn)
                .update(\.status, to: .deleted)
                .run()
        }
    }
}

// MARK: ServiceType conformances
extension PlaceRepository: ServiceType {
    static let serviceSupports: [Any.Type] = [PlaceRepositoryInterface.self]

    static func makeService(for worker: Container) throws -> Self {
        return .init(try worker.connectionPool(to: .psql))
    }
}

extension Database {
    typealias ConnectionPool = DatabaseConnectionPool<ConfiguredDatabase<Self>>
}
