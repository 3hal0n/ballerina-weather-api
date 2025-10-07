import ballerina/http;
import ballerina/log;
import ballerina/os;
import ballerina/time;

// Configuration for OpenWeatherMap API key - reads from environment variable or config
string OPENWEATHER_API_KEY = os:getEnv("OPENWEATHER_API_KEY");

// OpenWeatherMap API base URL
const string OPENWEATHER_BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

// HTTP client configuration with connection pooling and timeouts
http:ClientConfiguration clientConfig = {
    poolConfig: {
        maxActiveConnections: 50,
        maxIdleConnections: 25,
        waitTimeInMillis: 60000
    },
    timeout: 30.0,
    retryConfig: {
        count: 3,
        interval: 2.0
    }
};

// HTTP client for calling OpenWeatherMap API
http:Client openWeatherClient = check new (OPENWEATHER_BASE_URL, clientConfig);

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
    string name?;
    record {
        float temp;
    } main?;
    record {
        string main;
        string description;
    }[] weather?;
    string message?;
    int cod?;
};

// Weather service on port 8080
@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173", "http://localhost:5174"],
        allowCredentials: false,
        allowHeaders: ["CORELATION_ID", "Content-Type"],
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}
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
        string? cityName = weatherData?.name;
        float? temperature = weatherData?.main?.temp;
        string? description = ();
        
        // Safely extract weather description from array
        if weatherData?.weather is record {string main; string description;}[] {
            record {string main; string description;}[]? weatherArray = weatherData?.weather;
            if weatherArray is record {string main; string description;}[] && weatherArray.length() > 0 {
                description = weatherArray[0].description;
            }
        }

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

// Health check service on port 8081
service /health on new http:Listener(8081) {
    
    // Liveness probe - indicates if the application is running
    resource function get live() returns json {
        return {
            "status": "UP",
            "timestamp": time:utcNow(),
            "service": "weather-api",
            "version": "1.0.0"
        };
    }
    
    // Readiness probe - indicates if the application is ready to accept traffic
    resource function get ready() returns json|http:InternalServerError {
        // Check if API key is configured
        if OPENWEATHER_API_KEY.length() == 0 {
            http:InternalServerError serviceUnavailable = {
                body: {
                    "status": "DOWN",
                    "reason": "API key not configured",
                    "timestamp": time:utcNow()
                }
            };
            return serviceUnavailable;
        }
        
        // TODO: Add external dependency checks here
        // For example, test connection to OpenWeatherMap API
        
        return {
            "status": "READY",
            "timestamp": time:utcNow(),
            "dependencies": {
                "openweathermap": "OK"
            }
        };
    }
}

public function main() returns error? {
    log:printInfo("Weather API service started on port 8080");
    log:printInfo("Health check service started on port 8081");
    log:printInfo("Available endpoints:");
    log:printInfo("  - GET /weather/current?city={city_name}");
    log:printInfo("  - GET /health/live");
    log:printInfo("  - GET /health/ready");
}