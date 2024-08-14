//
//  UserService.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
//

import Firebase

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            
            completion(user)
        }
    }
}
