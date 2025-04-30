import Foundation
import SwiftUI

struct Artwork: Identifiable, Hashable {
    let id = UUID()
    let image: String
    let title: String
    let artist: String
    let medium: String
    let description: String
    let inspiration: String
    let relatedImages: [String]
    let location: String
    let timePosted: String
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        lhs.id == rhs.id
    }
}

// Sample data
class ArtworkData {
    static let samples = [
        Artwork(
            image: "apple",
            title: "Apple",
            artist: "Sai",
            medium: "Colored pencil",
            description: "A crisp apple, captured in vivid color, reflecting the essence of autumn.",
            inspiration: "I was inspired by the simple beauty of seasonal fruits and wanted to capture the perfect moment of ripeness.",
            relatedImages: ["apple-sketch-1", "apple-sketch-2", "apple-close-up"],
            location: "Tokyo",
            timePosted: "5 hrs ago"
        ),
        Artwork(
            image: "summer",
            title: "Summer",
            artist: "Tong Cui",
            medium: "Ink",
            description: "A long summer, a beautiful season full of memories and longing...",
            inspiration: "The long summer days I spent with friends—sitting by the water, laughing until sunset, and feeling like time stood still. I wanted to capture that mix of happiness and the quiet longing that comes when those moments turn into memories.",
            relatedImages: ["summer-sketch-1", "summer-watermelon", "summer-forest"],
            location: "China",
            timePosted: "3 hrs ago"
        ),
        Artwork(
            image: "heavy_rain",
            title: "大雨",
            artist: "Qing Ye",
            medium: "Poetry",
            description: "The sound of heavy rain against the window, a moment of peaceful solitude.",
            inspiration: "During the monsoon season, I found myself listening to the rhythmic pattern of raindrops. Each drop tells a story of its journey from sky to earth.",
            relatedImages: ["rain-sketch-1", "rain-window", "rain-puddles"],
            location: "Shanghai",
            timePosted: "1 day ago"
        )
    ]
}

// Life Updates Models
struct Update: Identifiable, Hashable {
    let id = UUID()
    let username: String
    let content: String
    let hasImage: Bool
    let imageName: String?
    let timeAgo: String
    
    init(username: String, content: String, timeAgo: String, imageName: String? = nil) {
        self.username = username
        self.content = content
        self.hasImage = imageName != nil
        self.imageName = imageName
        self.timeAgo = timeAgo
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Update, rhs: Update) -> Bool {
        lhs.id == rhs.id
    }
}

class UpdatesData {
    static let samples = [
        Update(
            username: "Vicky",
            content: "Michelin is a scheme.\nLife is a scheme.",
            timeAgo: "1 hr ago"
        ),
        Update(
            username: "PickleLover",
            content: "Check this out.",
            timeAgo: "1 hr ago",
            imageName: "turtle-image"
        ),
        Update(
            username: "Tong Cui",
            content: "Today I went past the Kangding Rd. and saw these beautiful watermelons.",
            timeAgo: "3 hrs ago",
            imageName: "watermelon-image"
        )
    ]
}
