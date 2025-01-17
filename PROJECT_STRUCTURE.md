# AI Malacca Tour Guide Project Structure

## Overview

The project follows a feature-first architecture with GetX for state management. Each feature is self-contained with its own views, controllers, and widgets.

## Key Components

### Features

Each feature module contains:

- **Controllers**: GetX controllers for state management
- **Views**: Main UI screens
- **Widgets**: Reusable UI components specific to the feature

### Models

Data models representing:

- Itineraries and their components
- Places and visits
- User data
- Weather information
- Transportation details

### Database

SQLite implementation with:

- Base helper class for database operations
- CRUD operations for each model type
- Table structures following the schema defined in project documentation

### Agents

LangChain-based AI agents for:

- Attraction recommendations
- Restaurant suggestions
- Budget filtering
- Itinerary optimization

### Utils & Config

- Constants and helper functions
- Theme and color definitions
- Environment configuration
- API helpers
- Image handling utilities

### Routes

- Centralized routing configuration
- Screen navigation management

## Dependencies

Key packages used:

- GetX for state management
- SQLite for local database
- LangChain for AI functionality
- Flutter Map for mapping features
- Geolocator for location services

This structure promotes:

- Feature isolation
- Code reusability
- Clear separation of concerns
- Easy maintenance and scalability

```
lib/
├── features/
│   ├── auth/
│   │   ├── controllers/
│   │   │   └── auth_controller.dart
│   │   └── views/
│   │       └── auth_view.dart
│   │
│   ├── chat/
│   │   ├── controllers/
│   │   │   └── chat_controller.dart
│   │   ├── views/
│   │   │   └── chat_view.dart
│   │   └── widgets/
│   │       └── itinerary_card.dart
│   │
│   ├── home/
│   │   ├── controllers/
│   │   │   └── home_controller.dart
│   │   ├── views/
│   │   │   └── home_page.dart
│   │   └── widgets/
│   │       ├── category_section.dart
│   │       ├── featured_trip_card.dart
│   │       ├── popular_trips_section.dart
│   │       └── search_bar_widget.dart
│   │
│   └── itinerary/
│       ├── controllers/
│       │   └── itinerary_controller.dart
│       ├── utils/
│       │   └── date_formatter.dart
│       ├── views/
│       │   ├── itinerary_view.dart
│       │   └── itinerary_details_view.dart
│       └── widgets/
│           ├── day_selector.dart
│           ├── empty_itinerary_view.dart
│           ├── error_view.dart
│           ├── itinerary_app_bar.dart
│           ├── itinerary_card_content.dart
│           ├── itinerary_content.dart
│           ├── itinerary_list_item.dart
│           ├── itinerary_map.dart
│           ├── loading_view.dart
│           ├── place_card.dart
│           ├── places_section.dart
│           ├── status_badge.dart
│           └── trip_info_section.dart
│
├── models/
│   ├── chat_response_model.dart
│   ├── day_itinerary_model.dart
│   ├── itinerary_model.dart
│   ├── place_itinerary_model.dart
│   └── user_model.dart
│
├── database/
│   └── crud/
│       ├── day_itineraries_crud.dart
│       ├── itineraries_crud.dart
│       └── place_itineraries_crud.dart
│
├── routes/
│   └── app_pages.dart
│
└── utils/
    └── place_images.dart
```

## Feature: Itinerary

### Views

- `itinerary_view.dart`: Main view for listing all itineraries
- `itinerary_details_view.dart`: Detailed view of a specific itinerary

### Widgets

- `day_selector.dart`: Horizontal list of days for navigation
- `empty_itinerary_view.dart`: Shown when no itineraries exist
- `error_view.dart`: Error state display
- `itinerary_app_bar.dart`: Custom app bar with background image
- `itinerary_card_content.dart`: Content section of itinerary card
- `itinerary_content.dart`: Main content layout for details view
- `itinerary_list_item.dart`: Individual itinerary card in the list
- `itinerary_map.dart`: Map view component
- `loading_view.dart`: Loading state display
- `place_card.dart`: Card displaying place information
- `places_section.dart`: Section showing places for selected day
- `status_badge.dart`: Status indicator badge
- `trip_info_section.dart`: Trip information display section

### Utils

- `date_formatter.dart`: Date formatting utility class

### Controller

- `itinerary_controller.dart`: State management and business logic

### Models

- `itinerary_model.dart`: Data model for itinerary
- `day_itinerary_model.dart`: Data model for daily itinerary
- `place_itinerary_model.dart`: Data model for places in itinerary

### Database

- `itineraries_crud.dart`: CRUD operations for itineraries
- `day_itineraries_crud.dart`: CRUD operations for daily itineraries
- `place_itineraries_crud.dart`: CRUD operations for places
