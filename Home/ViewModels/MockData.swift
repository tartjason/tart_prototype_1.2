import Foundation
import SwiftUI

// 导入模型
//import Models.Artwork

struct MockData {
    static let artworks: [Artwork] = [
        Artwork(
            id: "1",
            imageURL: "apple",
            title: "Apple",
            artist: "Sai",
            medium: "Colored pencil",
            description: "A crisp apple, captured in vivid color, reflecting the essence of autumn.",
            inspiration: "I was inspired by the simple beauty of seasonal fruits and wanted to capture the perfect moment of ripeness.",
            relatedImages: ["apple-sketch-1", "apple-sketch-2", "apple-close-up"],
            location: "Tokyo",
            createdAt: Date().addingTimeInterval(-5 * 3600),
            likes: 0,
            isLiked: false,
            isSaved: false,
            comments: []
        ),
        Artwork(
            id: "2",
            imageURL: "summer",
            title: "Summer",
            artist: "Tong Cui",
            medium: "Ink",
            description: "A long summer, a beautiful season full of memories and longing...",
            inspiration: "The long summer days I spent with friends—sitting by the water, laughing until sunset, and feeling like time stood still. I wanted to capture that mix of happiness and the quiet longing that comes when those moments turn into memories.",
            relatedImages: ["summer-sketch-1", "summer-watermelon", "summer-forest"],
            location: "China",
            createdAt: Date().addingTimeInterval(-3 * 3600),
            likes: 0,
            isLiked: false,
            isSaved: false,
            comments: []
        ),
        Artwork(
            id: "3",
            imageURL: "heavy_rain",
            title: "大雨",
            artist: "Qing Ye",
            medium: "Poetry",
            description: "The sound of heavy rain against the window, a moment of peaceful solitude.",
            inspiration: "During the monsoon season, I found myself listening to the rhythmic pattern of raindrops. Each drop tells a story of its journey from sky to earth.",
            relatedImages: ["rain-sketch-1", "rain-window", "rain-puddles"],
            location: "Shanghai",
            createdAt: Date().addingTimeInterval(-24 * 3600),
            likes: 0,
            isLiked: false,
            isSaved: false,
            comments: []
        )
    ]
} 
