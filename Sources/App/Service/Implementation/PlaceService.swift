//
//  PlaceService.swift
//  SkateBudapestBackend
//
//  Created by Horváth Balázs on 2018. 11. 21..
//

import Vapor

final class PlaceService {
    private let placeRepository: PlaceRepositoryInterface

    init(placeRepository: PlaceRepositoryInterface) {
        self.placeRepository = placeRepository
    }
}

// MARK: PlaceServiceInterface conformances
extension PlaceService: PlaceServiceInterface {
    func getPlaces(for languageCode: LanguageCode, status: PlaceStatus) -> Future<[PlaceResponseDTO]> {
        return placeRepository
            .findAllPlaces(status: status)
            .map(to: [PlaceResponseDTO].self) { result in
                let (places, images) = result
                return places.map { place in
                    let imageUrls = images
                        .filter { $0.placeId == place.id }
                        .map { $0.imageUrl }

                    return PlaceResponseDTO(place: place, placeImages: imageUrls, languageCode: languageCode)
                }
            }
    }

    func getPlaceDataVersion() -> Future<PlaceDataVersionResponseDTO> {
        return placeRepository
            .findPlaceDataVersion()
            .unwrap(or: Abort.init(HTTPResponseStatus.notFound))
            .map(to: PlaceDataVersionResponseDTO.self) {
                PlaceDataVersionResponseDTO(id: $0.id, dataVersion: $0.dataVersion)
            }
    }

    func getPlaceSuggestions(status: PlaceSuggestionStatus) -> Future<[PlaceSuggestionResponseDTO]> {
        return placeRepository
            .findPlaceSuggestions(status: status)
            .map(to: [PlaceSuggestionResponseDTO].self) { placeSuggestions in
                placeSuggestions.map { PlaceSuggestionResponseDTO(suggestion: $0) }
            }
    }

    func postPlaceSuggestion(suggestion: PlaceSuggestionRequestDTO, on request: Request) -> Future<HTTPResponse> {
        return placeRepository
            .savePlaceSuggestion(suggestion: suggestion.toPlaceSuggestion())
            .map(to: HTTPResponse.self) { _ in
                self.sendEmailToDeveloper(on: request)
                return HTTPResponse(status: .created,
                                    body: GeneralSuccessDTO(message: "Place suggestion is created!"))
            }
    }

    func clearPlaceSuggestions() -> Future<HTTPResponse> {
        return placeRepository
            .clearPlaceSuggestions()
            .map(to: HTTPResponse.self) { _ in
                return HTTPResponse(status: .ok,
                                    body: GeneralSuccessDTO(message: "Place suggestions are cleared!"))
        }
    }

    func getPlaceReports(status: PlaceReportStatus) -> EventLoopFuture<[PlaceReportResponseDTO]> {
        return placeRepository
             .findPlaceReports(status: status)
             .map(to: [PlaceReportResponseDTO].self) { placeReports in
                 placeReports.map { PlaceReportResponseDTO(report: $0) }
             }
    }

    func postPlaceReport(report: PlaceReportRequestDTO, on request: Request) -> EventLoopFuture<HTTPResponse> {
        return placeRepository
            .savePlaceReport(report: report.toPlaceReport())
            .map(to: HTTPResponse.self) { _ in
                return HTTPResponse(status: .created,
                                    body: GeneralSuccessDTO(message: "Place report is created!"))
            }
    }

    func clearPlaceReports() -> EventLoopFuture<HTTPResponse> {
        return placeRepository
            .clearPlaceReports()
            .map(to: HTTPResponse.self) { _ in
                return HTTPResponse(status: .ok,
                                    body: GeneralSuccessDTO(message: "Place reports are cleared!"))
        }
    }
}

extension PlaceService {
    private func sendEmailToDeveloper(on request: Request) {
        let message = MailGunMessageRequestDTO(
            from: "Skate Budapest <info@libertyskate.hu>",
            to: "balazs630@icloud.com",
            subject: "New place suggested",
            html: """
                <html>
                <p>Dear Developer,</p>
                <p>Someone just posted a new place suggestion from Skate Budapest iOS app.</p>
                <p>Go and check it out.</p>
                </html>
            """
        )

        MailGun.sendEmail(message: message, on: request)
    }
}
