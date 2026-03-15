//
//  FirebaseBreakService.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import FirebaseFirestore

final class FirebaseBreakService {
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    
    func startBreak(userId: String) async throws {

        try await db
            .collection("users")
            .document(userId)
            .collection("breaks")
            .document("current")
            .updateData([
                "startTime": FieldValue.serverTimestamp(),
                "status": "running",
                "breakTaken": true
            ])
    }
    
    // MARK: Observe Break (Realtime)
    
    func observeBreak(
        userId: String,
        onChange: @escaping (Break?) -> Void
    ) {
        
        listener = db
            .collection("users")
            .document(userId)
            .collection("breaks")
            .document("current")
            .addSnapshotListener { snapshot, error in
                
                guard let data = snapshot?.data() else {
                    onChange(nil)
                    return
                }
                
                let startTime = (data["startTime"] as? Timestamp)?.dateValue()
                let duration = data["duration"] as? Double ?? 0
                let status = data["status"] as? String ?? "not_started"
                let breakTaken = data["breakTaken"] as? Bool ?? false
                let endTime = (data["endTime"] as? Timestamp)?.dateValue()
                
                let breakModel = Break(
                    startTime: startTime,
                    duration: duration,
                    status: status,
                    breakTaken: breakTaken,
                    endTime: endTime
                )
                
                onChange(breakModel)
            }
    }
    
    // MARK: Fetch Break (One time)
    
    func fetchBreak(userId: String) async throws -> Break {
        
        let snapshot = try await db
            .collection("users")
            .document(userId)
            .collection("breaks")
            .document("current")
            .getDocument()
        
        guard let data = snapshot.data() else {
            throw NSError(domain: "BreakNotFound", code: 0)
        }
        
        let startTime = (data["startTime"] as? Timestamp)?.dateValue()
        let duration = data["duration"] as? Double ?? 0
        let status = data["status"] as? String ?? "not_started"
        let breakTaken = data["breakTaken"] as? Bool ?? false
        let endTime = (data["endTime"] as? Timestamp)?.dateValue()
        
        return Break(
            startTime: startTime,
            duration: duration,
            status: status,
            breakTaken: breakTaken,
            endTime: endTime
        )
    }
    
    // MARK: End Break Early
    
    func endBreakEarly(userId: String) async throws {
        
        try await db
            .collection("users")
            .document(userId)
            .collection("breaks")
            .document("current")
            .updateData([
                "status": "ended",
                "endTime": FieldValue.serverTimestamp()
            ])
    }
    
    
    func resetBreak(userId: String) async throws {

        try await db
            .collection("users")
            .document(userId)
            .collection("breaks")
            .document("current")
            .updateData([
                "startTime": NSNull(),
                "endTime": NSNull(),
                "breakTaken": false,
                "status": "not_started"
            ])
    }
    
    // MARK: Stop Listener
    
    func stopListening() {
        listener?.remove()
    }
}
