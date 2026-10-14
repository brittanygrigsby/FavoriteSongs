//
//  SongsViewModel.swift
//  FavoriteSongs
//
//  Created by Brittany Grigsby on 10/13/26.
//

import Foundation
import Combine
@MainActor
class SongsViewModel: ObservableObject {
    @Published var songs: [Song] = []
    @Published var isLoading = false
    @Published var loadError: String? // shown on the Favorite Songs screen
    @Published var saveError: String? // shown on the Add Song screen
    
    private let service = SongService()
    
    // Called when the list screen appears
    func loadSongs() async {
        isLoading = true
        do {
            songs = try await service.fetchSongs()
        } catch {
            loadError = error.localizedDescription
        }
        isLoading = false
    }
    
    // Called when the user taps Save Song.
    // Returns true if the song was saved.
    
    func addSong(title: String, artist: String, album: String) async -> Bool
    {
        let song = Song(
            id: UUID().uuidString,
            title: title,
            artist: artist,
            album: album
        )
        do {
            try await service.saveSong(song) // POST
            saveError = nil
            await loadSongs() // GET the updated list
            return true
        } catch {
            saveError = error.localizedDescription
            return false
        }
    }
}
