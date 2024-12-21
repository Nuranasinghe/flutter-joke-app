 # Joke App

A fun and interactive Flutter app that fetches jokes from an API, allows users to search jokes by category, and displays them in a beautiful UI. Users can tap the "Fetch Jokes" button to load jokes and use the search bar to filter jokes by their category.

## Features

- **Fetch Jokes**: Retrieves jokes from an API.
- **Search by Category**: Allows users to search jokes based on the category.
- **Beautiful UI**: Modern design with gradient backgrounds, elevated buttons, and card-style joke display.
- **Loading State**: A loading indicator is displayed when jokes are being fetched.


## Tech Stack

- **Flutter**: A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Dart**: Programming language used for building Flutter applications.

## Installation

### 1. Clone this repository:

```bash
git clone https://github.com/Nuranasinghe/flutter-joke-cache-app.git
```

### 2. Navigate into the project directory:

```bash
cd joke-app
```

### 3. Install dependencies:

```bash
flutter pub get
```

### 4. Run the app:

```bash
flutter run
```

## How to Use

1. When the app loads, tap the **"Fetch Jokes"** button to load jokes from the API.
2. Use the search bar to filter jokes by their category.
3. The jokes will be displayed in cards, and you can read both the setup and delivery (or just the joke itself).
4. In offline situation, the app will display cached jokes.

## Acknowledgements

- Thank you to [JokeAPI](https://v2.jokeapi.dev/) for providing the jokes API.
- Inspired by Flutter's simple yet powerful UI framework for mobile app development.

