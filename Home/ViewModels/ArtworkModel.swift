import Foundation
import SwiftUI

struct Artwork: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let artist: String
    let medium: String
}

// Sample data
class ArtworkData {
    static let samples = [
        Artwork(
            image: "apple",
            title: "Apple",
            artist: "Sai",
            medium: "Colored pencil"
        ),
        Artwork(
            image: "summer",
            title: "Summer",
            artist: "Tong Cui",
            medium: "Ink"
        ),
        Artwork(
            image: "heavy_rain",
            title: "大雨",
            artist: "Qing Ye",
            medium: "Poetry"
        )
    ]
}
