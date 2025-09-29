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

### 2. Configure the API Key

Edit the `Config.toml` file and replace `your_api_key_here` with your actual OpenWeatherMap API key:

```toml
[ballerina/http]
OPENWEATHER_API_KEY = "your_actual_api_key_here"
```

### 3. Run the Service

Navigate to the project directory and run:

```bash
bal run
```

The service will start on port 8080.

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
weatherAPI/
├── Ballerina.toml     # Project configuration
├── Config.toml        # API key configuration
├── main.bal          # Main service implementation
└── README.md         # This file
```

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