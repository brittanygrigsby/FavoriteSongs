//
//  ContentView.swift
//  FavoriteSongs
//
//  Created by Brittany Grigsby on 10/13/26.
//

import SwiftUI
struct ContentView: View {
    @StateObject private var viewModel = SongsViewModel()
    @State private var showAddSong = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.songs) { song in
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title)
                        .font(.headline)
                    Text(song.artist)
                        .font(.subheadline)
                    Text(song.album)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.songs.isEmpty {
                    Text("No songs yet. Tap + to add one.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("My Favorite Songs")
            
            .toolbar {
                Button {
                    showAddSong = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddSong) {
                AddSongView(viewModel: viewModel)
            }
                .task {
                    await viewModel.loadSongs() // GET when the app starts
                }
                .refreshable {
                    await viewModel.loadSongs() // pull down to reload
                }
                .alert("Something went wrong",
                       isPresented: Binding(
                        get: { viewModel.loadError != nil },
                        set: { if !$0 { viewModel.loadError = nil } }
                       )) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.loadError ?? "")
            }
        }
    }
}
