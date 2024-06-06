
# Chat Server

A server application built using the [Shelf](https://pub.dev/packages/shelf) package, designed for handling chat operations, user authentication, and more.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [API Endpoints](#api-endpoints)

## Features

- User authentication and management (registration, login, logout, token refresh)
- Chat management (create, update, delete chats, join/leave chats)
- Contact management (add/remove contacts, search users)
- Message management (send, delete, update messages)
- Post management (add, remove posts)
- Middleware for authentication, error handling, headers, and validation
- Database integration using Drift and PostgreSQL
- Email notifications using AWS SES
- JSON Web Token (JWT) based authentication

## Installation

### Prerequisites

- Dart SDK (>=3.4.0 <3.4.2)

### Steps

1. Clone the repository:

    ```sh
    git clone https://github.com/k0zlov/chat-server.git
    cd chat-server
    ```

2. Install dependencies:

    ```sh
    dart pub get
    ```

3. Set up environment variables:

    Create a `.env` file in the root directory and add the necessary environment variables:

    ```env
    DATABASE_PORT=
    DATABASE_NAME=
    DATABASE_PASSWORD=
    DATABASE_USERNAME=
    DATABASE_HOST=

    JWT_ACCESS_SECRET=
    JWT_REFRESH_SECRET=

    AWS_REGION=
    AWS_ACCESS_KEY=
    AWS_SECRET_KEY=

    BASE_URL=

    EMAIL_ADDRESS=
    ```

4. Run the server:

    ```sh
    dart run
    ```

## Usage

The server can be started using the `main.dart` file:

```sh
dart lib/main.dart
```

The server will start and listen on the configured IP and port, and you can interact with the available API endpoints.

## Project Structure

- `lib/controllers`: Contains the controllers for handling different types of operations (auth, chats, contacts, messages, posts).
- `lib/database`: Contains the database configuration and extensions for various models.
- `lib/middleware`: Contains middleware for authentication, error handling, headers, and request validation.
- `lib/models`: Contains the data models for the application.
- `lib/routes`: Contains route definitions for different parts of the API.
- `lib/server`: Contains the server configuration and main server class.
- `lib/services`: Contains services for handling emails and tokens.
- `lib/utils`: Contains utility functions for handling cookies, JWT tokens, and request validation.

## API Endpoints

Here is a brief overview of the main API endpoints. Detailed documentation can be found within each controller.

### Auth Controller

- `GET /auth/user`: Retrieve authenticated user details.
- `POST /auth/register`: Register a new user.
- `POST /auth/login`: Login a user.
- `POST /auth/logout`: Logout the authenticated user.
- `POST /auth/refresh`: Refresh the user's access token.

### Chats Controller

- `GET /chats`: Retrieve all chats for the authenticated user.
- `POST /chats`: Create a new chat.
- `DELETE /chats`: Delete a chat.
- `PUT /chats`: Update a chat.
- `POST /chats/join`: Join a chat.
- `POST /chats/leave`: Leave a chat.
- `GET /chats/search`: Search for chats by title.

### Contacts Controller

- `GET /contacts`: Retrieve all contacts for the authenticated user.
- `POST /contacts`: Add a new contact.
- `DELETE /contacts`: Remove a contact.
- `GET /contacts/search`: Search for users to add as contacts.

### Messages Controller

- `POST /messages`: Send a message.
- `DELETE /messages`: Delete a message.
- `PUT /messages`: Update a message.

### Posts Controller

- `GET /posts`: Retrieve all posts.
- `POST /posts`: Add a new post.
- `DELETE /posts`: Remove an existing post.
