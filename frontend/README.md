# Weather App Frontend

A modern React frontend for the Ballerina Weather API service.

## Features

- **Real-time Weather Data**: Get current weather information for any city
- **Recent Searches**: Automatically saves and displays your last 5 searched cities
- **Responsive Design**: Works seamlessly on desktop and mobile devices
- **Modern UI**: Clean, beautiful interface built with Tailwind CSS
- **Error Handling**: Comprehensive error messages and loading states
- **Local Storage**: Persists recent searches across browser sessions

## Tech Stack

- **React 19** - Latest version with modern hooks
- **Vite** - Fast build tool and development server
- **Tailwind CSS v4** - Utility-first CSS framework
- **ESLint** - Code linting and formatting

## Prerequisites

Before running the frontend, ensure you have:

1. **Node.js** (version 18 or higher)
2. **Ballerina Weather API** running on port 8080

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Start Development Server

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

### 3. Ensure Backend is Running

Make sure the Ballerina weather service is running on port 8080. From the parent directory:

```bash
# Make sure you have a valid OpenWeatherMap API key in Config.toml
bal run
```

## Usage

1. **Enter a City**: Type any city name in the search box
2. **Get Weather**: Click "Search" or press Enter
3. **View Results**: See current temperature and weather description
4. **Quick Access**: Click on recent searches for easy re-searching

## API Integration

The frontend communicates with the Ballerina backend at:
- **Endpoint**: `GET http://localhost:8080/weather/current`
- **Parameter**: `city` (query parameter)
- **Response**: JSON with `city`, `temperature`, and `description`

## Error Handling

The app handles various error scenarios:
- **Empty city name**: Validation error
- **City not found**: 404 error from API
- **Network issues**: Connection error to backend
- **Service unavailable**: Backend service not running

## Build for Production

```bash
npm run build
```

Built files will be in the `dist/` directory.

## Development Commands

```bash
npm run dev      # Start development server
npm run build    # Build for production  
npm run preview  # Preview production build
npm run lint     # Run ESLint
```

## Features Overview

### Recent Searches
- Automatically saves the last 5 searched cities
- Persisted in browser's localStorage
- Click any recent search to quickly re-search

### Responsive Design  
- Mobile-first approach with Tailwind CSS
- Works on all screen sizes
- Touch-friendly interface

### Loading States
- Animated spinner during API calls
- Disabled form during requests
- Clear visual feedback

### Error Messages
- User-friendly error messages
- Different messages for different error types
- Clear instructions for resolving issues
