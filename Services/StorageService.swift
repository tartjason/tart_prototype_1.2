import Foundation

// 导入模型
//import Models

class StorageService {
    static let shared = StorageService()
    
    private let fileManager = FileManager.default
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
        encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - Directory Management
    
    private func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func getCacheDirectory() -> URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Artwork Storage
    
    func saveArtworks(_ artworks: [Artwork]) throws {
        let url = getDocumentsDirectory().appendingPathComponent("artworks.json")
        let data = try encoder.encode(artworks)
        try data.write(to: url)
    }
    
    func loadArtworks() throws -> [Artwork] {
        let url = getDocumentsDirectory().appendingPathComponent("artworks.json")
        let data = try Data(contentsOf: url)
        return try decoder.decode([Artwork].self, from: data)
    }
    
    // MARK: - Life Updates Storage
    
    func saveLifeUpdates(_ updates: [LifeUpdate]) throws {
        let url = getDocumentsDirectory().appendingPathComponent("life_updates.json")
        let data = try encoder.encode(updates)
        try data.write(to: url)
    }
    
    func loadLifeUpdates() throws -> [LifeUpdate] {
        let url = getDocumentsDirectory().appendingPathComponent("life_updates.json")
        let data = try Data(contentsOf: url)
        return try decoder.decode([LifeUpdate].self, from: data)
    }
    
    // MARK: - Image Cache
    
    func cacheImage(_ imageData: Data, for url: URL) throws {
        let fileName = url.lastPathComponent
        let cacheURL = getCacheDirectory().appendingPathComponent(fileName)
        try imageData.write(to: cacheURL)
    }
    
    func getCachedImage(for url: URL) -> Data? {
        let fileName = url.lastPathComponent
        let cacheURL = getCacheDirectory().appendingPathComponent(fileName)
        return try? Data(contentsOf: cacheURL)
    }
    
    func clearImageCache() throws {
        let cacheURL = getCacheDirectory()
        let fileURLs = try fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil)
        for fileURL in fileURLs {
            try fileManager.removeItem(at: fileURL)
        }
    }
    
    // MARK: - Artwork Draft Storage
    
    func saveArtworkDrafts(_ drafts: [ArtworkDraft]) throws {
        let url = getDocumentsDirectory().appendingPathComponent("artwork_drafts.json")
        let data = try encoder.encode(drafts)
        try data.write(to: url)
    }
    
    func loadArtworkDrafts() throws -> [ArtworkDraft] {
        let url = getDocumentsDirectory().appendingPathComponent("artwork_drafts.json")
        guard fileManager.fileExists(atPath: url.path) else {
            return []
        }
        let data = try Data(contentsOf: url)
        return try decoder.decode([ArtworkDraft].self, from: data)
    }
    
    func deleteDraftFile(id: String) throws {
        let drafts = try loadArtworkDrafts()
        let updatedDrafts = drafts.filter { $0.id != id }
        try saveArtworkDrafts(updatedDrafts)
    }
    
    // MARK: - Clear All Data
    
    func clearAllData() throws {
        let documentsURL = getDocumentsDirectory()
        let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        for fileURL in fileURLs {
            try fileManager.removeItem(at: fileURL)
        }
        try clearImageCache()
    }
} 
