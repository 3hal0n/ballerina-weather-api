import ballerina/http;
import ballerina/log;

// Configuration for OpenWeatherMap API key
configurable string OPENWEATHER_API_KEY = ?;

// OpenWeatherMap API base URL
const string OPENWEATHER_BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

// HTTP client for calling OpenWeatherMap API
http:Client openWeatherClient = check new (OPENWEATHER_BASE_URL);

// Define the response type for our simplified weather data
type WeatherResponse record {
    string city;
    float temperature;
    string description;
};

// Define the error response type
type ErrorResponse record {
    string message;
    int code;
};

// OpenWeatherMap API response structure (simplified)
type OpenWeatherMapResponse record {
    record {
        string name;
    } name?;
    record {
        record {
            float temp;
        } main;
    } main?;
    record {
        record {
            string main;
            string description;
        }[] weather;
    } weather?;
    string message?;
    int cod?;
};

// Weather service on port 8080
service /weather on new http:Listener(8080) {
    
    // GET endpoint for current weather
    resource function get current(string city) returns WeatherResponse|ErrorResponse|error {
        
        // Validate city parameter
        if city.trim().length() == 0 {
            return <ErrorResponse>{
                message: "City parameter is required and cannot be empty",
                code: 400
            };
        }

        // Build the OpenWeatherMap API URL
        string apiUrl = string `?appid=${OPENWEATHER_API_KEY}&q=${city}&units=metric`;
        
        // Call OpenWeatherMap API
        http:Response|error openWeatherResponse = openWeatherClient->get(apiUrl);
        
        if openWeatherResponse is error {
            log:printError("Failed to call OpenWeatherMap API", 'error = openWeatherResponse);
            return <ErrorResponse>{
                message: "Failed to fetch weather data from external service",
                code: 503
            };
        }

        // Parse the JSON response
        json|error jsonResponse = openWeatherResponse.getJsonPayload();
        
        if jsonResponse is error {
            log:printError("Failed to parse OpenWeatherMap response", 'error = jsonResponse);
            return <ErrorResponse>{
                message: "Invalid response format from weather service",
                code: 502
            };
        }

        // Convert JSON to record for easier access
        OpenWeatherMapResponse|error weatherData = jsonResponse.cloneWithType();
        
        if weatherData is error {
            log:printError("Failed to convert weather data", 'error = weatherData);
            return <ErrorResponse>{
                message: "Failed to process weather data",
                code: 502
            };
        }

        // Check if the API returned an error (like city not found)
        if weatherData.cod is int && weatherData.cod != 200 {
            string errorMsg = weatherData.message ?: "Unknown error from weather service";
            return <ErrorResponse>{
                message: string `Weather data not found: ${errorMsg}`,
                code: weatherData.cod == 404 ? 404 : 400
            };
        }

        // Extract and validate required fields
        string? cityName = weatherData?.name?.name;
        float? temperature = weatherData?.main?.main?.temp;
        string? description = weatherData?.weather?.weather?[0]?.description;

        if cityName is () || temperature is () || description is () {
            return <ErrorResponse>{
                message: "Incomplete weather data received from service",
                code: 502
            };
        }

        // Return simplified weather response
        return <WeatherResponse>{
            city: cityName,
            temperature: temperature,
            description: description
        };
    }
}

public function main() returns error? {
    log:printInfo("Weather API service started on port 8080");
    log:printInfo("Available endpoint: GET /weather/current?city={city_name}");
}