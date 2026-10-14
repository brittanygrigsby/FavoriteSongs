//
//  AddSongView.swift
//  FavoriteSongs
//
//  Created by Brittany Grigsby on 10/13/26.
//
import SwiftUI
struct AddSongView: View {
    @ObservedObject var viewModel: SongsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var artist = ""
    @State private var album = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Song title",text: $title)
                }
                Section("Artist") {
                    TextField("Artist", text: $artist)
                }
                Section("Album") {
                    TextField("Album", text: $album)
                }
                if let error = viewModel.saveError {
                Text(error)
                        .foregroundStyle(.red)
                }
                
                Button("Save Song") {
                Task {
                    isSaving = true
                    let saved = await viewModel.addSong(
                        title: title, artist: artist, album: album
                    )
                    isSaving = false
                    if saved { dismiss() }
                    }
                }
                .disabled(title.isEmpty || artist.isEmpty || album.isEmpty ||
                isSaving)
            }
            .navigationTitle("Add Song")
            .toolbar {
                Button("Cancel") { dismiss() }
                }
            }
        }
    }
