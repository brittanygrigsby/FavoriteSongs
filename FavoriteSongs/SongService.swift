//
//  SongService.swift
//  FavoriteSongs
//
//  Created by Brittany Grigsby on 10/13/26.
//
import Foundation
// The errors our app can run into, with a message the user can read.
enum SongError: LocalizedError {
    case invalidURL
    case connectionFailed
    case invalidResponse
    case decodingFailed
    case saveFailed
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The Firebase URL is not valid."
        case .connectionFailed: return "Unable to connect to Firebase. Check your internet connection."
        case .invalidResponse: return "Firebase sent back an invalid response."
        case .decodingFailed: return "Unable to read the songs from Firebase."
        case .saveFailed: return "Unable to save the song. Please try again."
        }
    }
}
        
struct SongService {
    private let baseURL = "https://favorite-songs-a113c-default-rtdb.firebaseio.com"
    
    // GET → retrieve all songs
    func fetchSongs() async throws -> [Song] {
        guard let url = URL(string: "\(baseURL)/songs.json") else {
            throw SongError.invalidURL
        }
        
        // 1. Send the GET request
        let data: Data
        let response: URLResponse
        do {
        (data, response) = try await URLSession.shared.data(from: url)
        } catch {
        throw SongError.connectionFailed
        }
        
        // 2. Check that Firebase answered with 200 OK
        guard let http = response as? HTTPURLResponse, http.statusCode == 200
else {
        throw SongError.invalidResponse
        }
        
        // 3. Decode the JSON into Song objects
        do {
        let songsByKey = try JSONDecoder().decode([String: Song]?.self,
        from: data) ?? [:]
        let songs = songsByKey.values
        return songs.sorted { $0.title < $1.title }
        } catch {
        throw SongError.decodingFailed
        }
    }
        
    // POST → save one song
        func saveSong(_ song: Song) async throws {
            guard let url = URL(string: "\(baseURL)/songs.json") else {
                throw SongError.invalidURL
        }
            
        // 1. Build the POST request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // 2. Encode the song into JSON and put it in the body
        request.httpBody = try JSONEncoder().encode(song)
        
        // 3. Send it and check the response
        do {
        let (_, response) = try await URLSession.shared.data(for:request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                throw SongError.saveFailed
            }
        } catch {
            throw SongError.saveFailed
        }
    }
}
        
        
