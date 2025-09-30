# Weather API Service

A simple Ballerina-based REST API service that provides current weather information by integrating with the OpenWeatherMap API.

## Features

- REST API endpoint on port 8080
- Fetches live weather data from OpenWeatherMap
- Returns simplified JSON response with city, temperature, and description
- Comprehensive error handling for API failures and invalid requests
- Configurable API key management

## Prerequisites

- Ballerina Swan Lake (2201.8.0 or later)
- OpenWeatherMap API key (free at https://openweathermap.org/api)

## Setup Instructions

### 1. Get OpenWeatherMap API Key

1. Visit https://openweathermap.org/api
2. Sign up for a free account
3. Generate an API key from your dashboard

### 2. Configure the API Key (Secure Methods)

Choose one of these secure methods to configure your API key:

#### **Method A: Environment Variable (Recommended)**

1. Create a `.env` file in the project root:
```env
OPENWEATHER_API_KEY=your_actual_api_key_here
```

2. Run using the PowerShell script:
```powershell
.\start-service.ps1
```

Or manually set the environment variable:
```powershell
$env:OPENWEATHER_API_KEY="your_actual_api_key_here"
bal run
```

#### **Method B: Config File (Alternative)**

1. Copy the template: `copy Config.toml.template Config.toml`
2. Edit `Config.toml` and add your API key:
```toml
OPENWEATHER_API_KEY = "your_actual_api_key_here"
```

⚠️ **Security Note**: `Config.toml` is in `.gitignore` to prevent committing API keys.

### 3. Run the Backend Service

```bash
bal run
```

The service will start on port 8080.

### 4. Run the Frontend (Optional)

For the complete user experience with the React frontend:

```bash
cd frontend
npm install
npm run dev
```

The frontend will be available at `http://localhost:5173`

## Quick Start

For the fastest setup:

1. **Get API Key**: Sign up at https://openweathermap.org/api
2. **Configure**: Update `Config.toml` with your API key  
3. **Start Backend**: Run `bal run` (service on port 8080)
4. **Start Frontend**: In `frontend/` directory, run `npm install && npm run dev` (UI on port 5173)

## API Usage

### Endpoint

```
GET /weather/current?city={city_name}
```

### Example Request

```bash
curl "http://localhost:8080/weather/current?city=London"
```

### Successful Response

```json
{
  "city": "London",
  "temperature": 15.5,
  "description": "clear sky"
}
```

### Error Response

```json
{
  "message": "Weather data not found: city not found",
  "code": 404
}
```

## Error Codes

- `400`: Bad Request (missing or empty city parameter)
- `404`: City not found
- `502`: Bad Gateway (invalid response from OpenWeatherMap)
- `503`: Service Unavailable (OpenWeatherMap API unreachable)

## Project Structure

```
ballerina-weather-api/
├── Ballerina.toml     # Project configuration
├── Config.toml        # API key configuration
├── main.bal          # Main service implementation
├── frontend/          # React frontend application
│   ├── src/
│   │   ├── App.jsx    # Main weather component
│   │   ├── App.css    # App styles
│   │   ├── main.jsx   # React entry point
│   │   └── index.css  # Tailwind CSS imports
│   ├── package.json   # Frontend dependencies
│   └── README.md      # Frontend documentation
└── README.md         # This file
```

## Frontend Application

This project includes a modern React frontend that provides a user-friendly interface for the weather API.

### Features:
- **Modern UI**: Clean, responsive design with Tailwind CSS
- **Real-time Search**: Instant weather data for any city
- **Recent Searches**: Automatically saves your last 5 searches
- **Error Handling**: Comprehensive error messages and loading states
- **Mobile Responsive**: Works seamlessly on all devices

### Running the Frontend:

1. **Start the Backend**: Make sure the Ballerina service is running on port 8080
2. **Navigate to Frontend**: `cd frontend`
3. **Install Dependencies**: `npm install`
4. **Start Development Server**: `npm run dev`
5. **Open Browser**: Visit `http://localhost:5173`

See `frontend/README.md` for detailed frontend documentation.

## API Integration Details

This service integrates with OpenWeatherMap's Current Weather Data API:
- Base URL: `https://api.openweathermap.org/data/2.5/weather`
- Uses metric units (Celsius for temperature)
- Handles API rate limits and errors gracefully

## Development Notes

- The service includes proper logging for debugging
- Temperature is returned in Celsius
- All API responses are properly validated before transformation
- The service gracefully handles network failures and malformed responses

## Future Enhancements

This basic service can be extended with:
- Authentication and authorization
- Rate limiting
- Caching for improved performance
- Multiple weather endpoints (forecast, historical data)
- Database integration for storing weather history
- Integration with WSO2 API Manager for advanced API management

## WSO2 API Manager Integration

To deploy this service behind WSO2 API Manager:

1. Deploy the Ballerina service as usual
2. Create a new API in WSO2 API Manager pointing to `http://localhost:8080`
3. Configure security policies (API Key, OAuth, etc.)
4. Set up rate limiting and throttling policies
5. Enable analytics to monitor API usage
6. Publish the API for consumers

This enables enterprise-grade API management features like monetization, analytics, and governance.