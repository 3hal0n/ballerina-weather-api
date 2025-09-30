# WSO2 Integration Guide for Weather API

## 🏢 Enterprise Integration with WSO2 Stack

This document outlines how to integrate the Ballerina Weather API with various WSO2 products for enterprise deployment.

## 🎯 WSO2 API Manager Integration

### Quick Setup
1. **Deploy Ballerina Service**
   ```bash
   bal run  # Service runs on port 8080
   ```

2. **Create API in WSO2 API Manager**
   - API Name: `Weather API`
   - Context: `/weather/v1`
   - Backend URL: `http://your-server:8080`

3. **Configure Security**
   ```yaml
   security_schemes:
     - oauth2
     - api_key
   rate_limiting:
     requests_per_minute: 1000
     burst_limit: 100
   ```

### Enterprise Features Available
- ✅ **OAuth 2.0 / JWT Authentication**
- ✅ **Rate Limiting & Throttling**
- ✅ **API Analytics & Monitoring**
- ✅ **Developer Portal**
- ✅ **API Versioning**
- ✅ **Request/Response Transformation**

## 🚀 WSO2 Choreo Deployment

### Cloud-Native Deployment
```yaml
# choreo.yaml
apiVersion: core.choreo.dev/v1beta1
kind: Component
metadata:
  name: weather-api
spec:
  type: service
  port: 8080
  env:
    - name: OPENWEATHER_API_KEY
      valueFrom:
        secretKeyRef:
          name: weather-secrets
          key: api-key
```

### Benefits
- **Auto-scaling**: Based on traffic patterns
- **Built-in Monitoring**: Observability out of the box
- **GitOps**: Automated deployments
- **Multi-environment**: Dev, staging, production

## 🔄 WSO2 Enterprise Integrator

### Message Mediation
```xml
<!-- Weather API Proxy Service -->
<proxy name="WeatherProxy" startOnLoad="true">
    <target>
        <inSequence>
            <log level="info" category="REQUEST"/>
            <call>
                <endpoint>
                    <http uri-template="http://ballerina-service:8080/weather/current"/>
                </endpoint>
            </call>
            <respond/>
        </inSequence>
    </target>
</proxy>
```

### Integration Patterns
- **Content-Based Router**: Route based on request parameters
- **Message Transformer**: Convert between different formats
- **Error Handler**: Centralized error management
- **Circuit Breaker**: Fault tolerance patterns

## 📊 WSO2 Streaming Integrator

### Real-Time Weather Processing
```sql
-- Stream Processing for Weather Alerts
@source(type='http', receiver.url="http://localhost:8080/weather/current")
define stream WeatherInputStream (city string, temperature double, description string);

@sink(type='log')
define stream AlertStream (city string, temperature double, alert string);

from WeatherInputStream
select city, temperature, 
       ifThenElse(temperature > 35.0, "HEAT_WARNING", "NORMAL") as alert
insert into AlertStream;
```

### Use Cases
- **Real-time Alerts**: Temperature threshold monitoring
- **Data Aggregation**: Weather pattern analysis
- **Event Correlation**: Multi-source weather data
- **Stream Analytics**: Historical weather trends

## 🛠️ Development Tools

### Ballerina Features for WSO2 Integration
```ballerina
// Built-in observability
import ballerina/observe;

// Health check endpoint
service /health on new http:Listener(8081) {
    resource function get status() returns json {
        return {"status": "UP", "service": "weather-api"};
    }
}

// Metrics collection
@observe:Observable
public function fetchWeatherData(string city) returns json|error {
    // Function automatically tracked for metrics
}
```

## 🔐 Security Integration

### WSO2 Identity Server Integration
```ballerina
import ballerina/jwt;
import ballerina/oauth2;

// JWT token validation
@http:ServiceConfig {
    auth: [
        {
            jwtValidatorConfig: {
                issuer: "https://wso2is.example.com/oauth2/token",
                audience: "weather-api",
                signatureConfig: {
                    jwksConfig: {
                        url: "https://wso2is.example.com/oauth2/jwks"
                    }
                }
            }
        }
    ]
}
service /weather on new http:Listener(8080) {
    // Secured endpoints
}
```

## 📈 Monitoring & Analytics

### WSO2 API Manager Analytics
- **API Usage Statistics**: Request counts, response times
- **Error Rate Monitoring**: 4xx/5xx error tracking
- **Geolocation Analytics**: User distribution maps
- **Custom Dashboards**: Business-specific metrics

### Integration with ELK Stack
```yaml
# Logstash configuration for Ballerina logs
input {
  beats {
    port => 5044
  }
}

filter {
  if [service] == "weather-api" {
    json {
      source => "message"
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "weather-api-logs"
  }
}
```

## 🌐 Multi-Protocol Support

### GraphQL API with WSO2 API Manager
```ballerina
// GraphQL schema for weather data
type Query {
    weather(city: String!): WeatherData
    forecast(city: String!, days: Int!): [WeatherData]
}

type WeatherData {
    city: String!
    temperature: Float!
    description: String!
    humidity: Int
    windSpeed: Float
}
```

### gRPC Support
```proto
// weather.proto
service WeatherService {
    rpc GetCurrentWeather(WeatherRequest) returns (WeatherResponse);
    rpc GetForecast(ForecastRequest) returns (stream WeatherResponse);
}
```

## 🔄 CI/CD with WSO2

### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'bal build'
            }
        }
        stage('Test') {
            steps {
                sh 'bal test'
            }
        }
        stage('Deploy to Choreo') {
            steps {
                sh 'choreo deploy --project weather-api'
            }
        }
        stage('Register in API Manager') {
            steps {
                sh 'apim import-api --file api-definition.yaml'
            }
        }
    }
}
```

## 📋 Best Practices Checklist

### Production Readiness
- [ ] **Health Checks**: Implement `/health` endpoint
- [ ] **Metrics**: Enable observability features
- [ ] **Security**: Configure authentication/authorization
- [ ] **Rate Limiting**: Set appropriate limits
- [ ] **Error Handling**: Comprehensive error responses
- [ ] **Logging**: Structured logging with correlation IDs
- [ ] **Documentation**: OpenAPI specification
- [ ] **Testing**: Unit and integration tests

### WSO2 Integration
- [ ] **API Manager**: Register and configure API
- [ ] **Security Policies**: Apply appropriate security
- [ ] **Analytics**: Enable usage analytics
- [ ] **Developer Portal**: Publish for developers
- [ ] **Versioning**: Implement API versioning strategy
- [ ] **Monitoring**: Set up alerts and dashboards

This integration guide ensures your Weather API is enterprise-ready and fully leverages the WSO2 ecosystem for production deployment.