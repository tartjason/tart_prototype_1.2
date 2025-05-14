import Foundation

struct ProfileUser {
    private(set) var baseUser: User
    var phoneNumber: String
    var connections: Int
    var isArtist: Bool
    
    var id: String { baseUser.id }
    var name: String { baseUser.username }
    var username: String { baseUser.username }
    var bio: String { baseUser.bio ?? "" }
    var email: String { baseUser.email }
    var profileImageURL: String? { baseUser.profileImageURL }
    
    mutating func updateProfile(name: String, username: String, bio: String, email: String) {
        baseUser = User(
            id: baseUser.id,
            email: email,
            username: username,
            profileImageURL: baseUser.profileImageURL,
            bio: bio,
            createdAt: baseUser.createdAt,
            updatedAt: Date()
        )
    }
    
    static var `default`: ProfileUser {
        ProfileUser(
            baseUser: User(
                id: UUID().uuidString,
                email: "jason.soltart@gmail.com",
                username: "jajasoso",
                profileImageURL: nil,
                bio: ""
            ),
            phoneNumber: "+1111",
            connections: 6,
            isArtist: false
        )
    }
}

// MARK: - Identifiable
extension ProfileUser: Identifiable {}

// MARK: - Hashable
extension ProfileUser: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ProfileUser, rhs: ProfileUser) -> Bool {
        lhs.id == rhs.id
    }
} 