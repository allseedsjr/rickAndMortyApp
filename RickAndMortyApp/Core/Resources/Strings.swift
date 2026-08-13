enum Strings {
    enum Common {
        static let retry = "Retry"
        static let cancel = "Cancel"
        static let unavailable = "Unavailable"
    }

    enum Home {
        static let title = "List of Characters"
        static let searchPlaceholder = "Search characters"
        static let searchAccessibilityLabel = "Search characters"
        static let searchEmptyState = "No characters found."
    }

    enum Details {
        static let species = "Species"
        static let gender = "Gender"
        static let origin = "Origin"
        static let location = "Location"
        static let episodes = "Episodes"
        static let firstSeenIn = "First seen in"
        static let backAccessibilityLabel = "Back"
    }

    enum CharacterStatus {
        static let alive = "Alive"
        static let dead = "Dead"
        static let unknown = "Unknown"
    }

    enum CharacterGender {
        static let female = "Female"
        static let male = "Male"
        static let genderless = "Genderless"
        static let unknown = "Unknown"
    }

    enum CharacterSpecies {
        static let human = "Human"
        static let alien = "Alien"
        static let humanoid = "Humanoid"
        static let animal = "Animal"
        static let robot = "Robot"
        static let mythologicalCreature = "Mythological Creature"
        static let poopybutthole = "Poopybutthole"
        static let cronenberg = "Cronenberg"
        static let disease = "Disease"
        static let planet = "Planet"
        static let unknown = "Unknown"
    }

    enum Error {
        static let offlineTitle = "No internet connection"
        static let offlineMessage = "Check your connection and try again."
        static let timeoutTitle = "Request timed out"
        static let timeoutMessage = "The server took too long to respond. Please try again."
        static let rateLimitedTitle = "Too many requests"
        static let rateLimitedMessage = "Please wait a moment before trying again."
        static let serviceUnavailableTitle = "Service unavailable"
        static let serviceUnavailableMessage = "The service is temporarily unavailable. Please try again shortly."
        static let genericTitle = "Something went wrong"
        static let genericMessage = "Unable to complete the request. Please try again."
        static let invalidDataMessage = "We couldn't process the server response."
        static let accessDeniedMessage = "The service denied access to this request."
        static let notFoundMessage = "The requested content could not be found."
    }
}
