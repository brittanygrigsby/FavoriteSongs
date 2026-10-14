# The Favorite Songs App

## How the app saves a song
The user enters a song -> Song model -> JSONEncoder -> URLSession (POST) -> Firebase
## How the app retrieves songs 
Firebase -> URLSession (GET) -> JSON response -> JSONDecoder -> Song ->SwiftUI List
## Where JSON encoding and decoding are used
JSON encoder turns a song into JSON on the way out and JSONDecoder turns JSON back into the song on the way in.
## What GET and POST do in this project
A song goes to Firebase through POST and comes back through GET
