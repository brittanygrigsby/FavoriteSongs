//
//  Song.swift
//  FavoriteSongs
//
//  Created by Brittany Grigsby on 10/13/26.
//
import Foundation

struct Song: Codable, Identifiable {
    let id: String
    let title: String
    let artist: String
    let album: String
}
