# 🌤️ Weather API Service with WSO2 Ballerina

[![Ballerina](https://img.shields.io/badge/Ballerina-2201.8.0-blue.svg)](https://ballerina.io/)
[![React](https://img.shields.io/badge/React-19.1.1-61DAFB.svg)](https://reactjs.org/)
[![WSO2](https://img.shields.io/badge/WSO2-Ready-orange.svg)](https://wso2.com/)

A modern, cloud-native weather API service built with **WSO2 Ballerina** and featuring a responsive React frontend. This project demonstrates enterprise-grade API development using WSO2's open-source technology stack.

## 🏗️ **WSO2 Technology Stack**

This project showcases several WSO2 technologies and best practices:

### **🎯 Primary WSO2 Products Used:**

- **[WSO2 Ballerina](https://ballerina.io/)** - Cloud-native programming language for integration
  - Type-safe HTTP service development
  - Built-in observability features
  - Native support for microservices patterns
  - Sequence diagram visualization of code flow

- **WSO2 API Manager Ready** - Enterprise API management capabilities
  - API gateway integration
  - Security policies and rate limiting
  - Developer portal compatibility
  - Analytics and monitoring ready

### **🔧 Ballerina Features Demonstrated:**

- **HTTP Services**: RESTful API with built-in CORS support
- **Error Handling**: Comprehensive error management with typed responses
- **Configuration Management**: Environment variable support with secure API key handling
- **Observability**: Built-in logging and monitoring capabilities
- **Type Safety**: Strong typing for API contracts and data structures
- **Client Generation**: HTTP client for external API integration

## 🌟 **Features**

### **Backend (WSO2 Ballerina)**
- ✅ RESTful weather API service
- ✅ Integration with OpenWeatherMap API
- ✅ Comprehensive error handling and validation
- ✅ CORS support for cross-origin requests
- ✅ Environment-based configuration
- ✅ Built-in observability and logging
- ✅ Type-safe JSON processing
- ✅ Production-ready HTTP service

### **Frontend (React)**
- ✅ Modern React 19 with hooks
- ✅ Responsive design with Tailwind CSS v4
- ✅ Real-time weather search
- ✅ Local storage for recent searches
- ✅ Comprehensive error handling
- ✅ Loading states and user feedback
- ✅ Mobile-optimized interface

## 🚀 **Quick Start**

### **Prerequisites**

- **[Ballerina Swan Lake](https://ballerina.io/downloads/)** (2201.8.0 or later) - WSO2's integration language
- **[Node.js](https://nodejs.org/)** (18+ for React frontend)
- **OpenWeatherMap API Key** (free at [openweathermap.org](https://openweathermap.org/api))

### **1. Clone the Repository**

```bash
git clone https://github.com/your-username/ballerina-weather-api.git
cd ballerina-weather-api
```

### **2. Get OpenWeatherMap API Key**

1. Visit [OpenWeatherMap API](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key

### **3. Configure API Key (Secure Method)**

Create a `.env` file in the project root:

```env
OPENWEATHER_API_KEY=your_actual_api_key_here
```

### **4. Start the Backend Service**

**Option A: Using PowerShell Script (Recommended)**
```powershell
.\start-service.ps1
```

**Option B: Manual Setup**
```powershell
$env:OPENWEATHER_API_KEY="your_actual_api_key_here"
bal run
```

The Ballerina service will start on **port 8080**.

### **5. Start the Frontend (Optional)**

```bash
cd frontend
npm install
npm run dev
```

The React app will be available at **http://localhost:5173** (or 5174 if 5173 is busy).

## 📊 **WSO2 API Manager Integration**

This Ballerina service is designed for seamless integration with WSO2 API Manager:

### **🎯 API Management Features:**

1. **API Gateway Integration**
   ```bash
   # Deploy to WSO2 API Manager
   # Point API Manager to: http://your-server:8080/weather
   ```

2. **Security Policies**
   - OAuth 2.0 authentication
   - API Key validation
   - JWT token validation
   - Rate limiting and throttling

3. **Developer Portal**
   - Auto-generated API documentation
   - Interactive API console
   - SDK generation for multiple languages

4. **Analytics & Monitoring**
   - Real-time API usage statistics
   - Performance monitoring
   - Error rate tracking
   - Business analytics

### **🔒 Enterprise Security Features:**

- **Authentication**: OAuth, API Key, JWT support
- **Authorization**: Role-based access control
- **Rate Limiting**: Request throttling policies
- **Data Security**: Request/response transformation
- **Audit Logging**: Complete API access logs

### **📈 Production Deployment:**

```yaml
# WSO2 API Manager Configuration
api:
  name: "Weather API"
  context: "/weather/v1"
  version: "1.0.0"
  backend: "http://ballerina-service:8080"
  security:
    - oauth2
    - api_key
  rate_limiting:
    requests_per_minute: 1000
```

## 🏛️ **Architecture Overview**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React App     │    │ WSO2 Ballerina  │    │ OpenWeatherMap  │
│   (Frontend)    │───▶│   (Backend)     │───▶│      API        │
│                 │    │                 │    │                 │
│ • Tailwind CSS  │    │ • HTTP Service  │    │ • Weather Data  │
│ • State Mgmt    │    │ • Error Handling│    │ • Global Cities │
│ • Local Storage │    │ • Type Safety   │    │ • Real-time     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │API Gateway (opt)│
                    │ (WSO2 API Mgr)  │
                    └─────────────────┘
```

## 📡 **API Documentation**

### **Endpoint**
```
GET /weather/current?city={city_name}
```

### **Request Parameters**
| Parameter | Type   | Required | Description           |
|-----------|--------|----------|-----------------------|
| `city`    | string | Yes      | Name of the city      |

### **Response Format**

**Success Response (200)**
```json
{
  "city": "London",
  "temperature": 15.5,
  "description": "clear sky"
}
```

**Error Response (4xx/5xx)**
```json
{
  "message": "City not found",
  "code": 404
}
```

### **Error Codes**
| Code | Description                              |
|------|------------------------------------------|
| 400  | Bad Request (missing/empty city)         |
| 404  | City not found                           |
| 502  | Bad Gateway (external API error)        |
| 503  | Service Unavailable (API unreachable)   |

## 🗂️ **Project Structure**

```
ballerina-weather-api/
├── 📁 WSO2 Ballerina Backend
│   ├── main.bal              # Main service implementation
│   ├── Ballerina.toml        # Project metadata & dependencies
│   ├── Dependencies.toml     # Auto-generated dependencies
│   ├── Config.toml.template  # Configuration template
│   └── start-service.ps1     # Windows startup script
│
├── 📁 React Frontend
│   ├── src/
│   │   ├── App.jsx           # Main weather component
│   │   ├── main.jsx          # React entry point
│   │   └── index.css         # Tailwind CSS
│   ├── package.json          # Dependencies
│   └── vite.config.js        # Build configuration
│
├── 📁 Security & Config
│   ├── .env                  # Environment variables (gitignored)
│   ├── .gitignore           # Git ignore rules
│   └── Config.toml.template  # Secure config template
│
└── 📁 Documentation
    ├── README.md             # This file
    └── frontend/README.md    # Frontend documentation
```

## 🔧 **Development**

### **Backend Development (Ballerina)**

```bash
# Install Ballerina dependencies
bal build

# Run with hot reload (development)
bal run

# Generate Ballerina documentation
bal doc

# Run tests
bal test
```

### **Frontend Development (React)**

```bash
cd frontend

# Install dependencies
npm install

# Development server with hot reload
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 🌐 **WSO2 Integration Scenarios**

### **1. Microservices Architecture**
- Deploy as a containerized Ballerina service
- Use WSO2 Choreo for cloud deployment
- Integrate with WSO2 service mesh

### **2. Enterprise API Gateway**
- Front with WSO2 API Manager
- Apply enterprise security policies
- Monitor with WSO2 analytics

### **3. Integration Platform**
- Connect with WSO2 Enterprise Integrator
- Add message transformation
- Implement enterprise integration patterns

### **4. Event-Driven Architecture**
- Use WSO2 Streaming Integrator
- Add real-time weather alerts
- Implement event streaming

## 🚀 **Deployment Options**

### **Local Development**
```bash
# Start backend
.\start-service.ps1

# Start frontend (separate terminal)
cd frontend && npm run dev
```

### **Docker Deployment**
```dockerfile
# Ballerina service containerization
FROM ballerina/ballerina:2201.8.0
COPY . /app
WORKDIR /app
RUN bal build
EXPOSE 8080
CMD ["bal", "run"]
```

### **WSO2 Choreo Deployment**
```yaml
# Deploy to WSO2's cloud platform
apiVersion: v1
kind: Service
metadata:
  name: weather-api
spec:
  backend: ballerina-service
  replicas: 3
  resources:
    memory: "512Mi"
    cpu: "250m"
```

## 🔐 **Security Best Practices**

### **API Key Management**
- ✅ Environment variables for sensitive data
- ✅ `.env` file gitignored
- ✅ Template configuration provided
- ✅ No hardcoded secrets in code

### **CORS Configuration**
- ✅ Explicit origin allowlist
- ✅ Secure header validation
- ✅ Method restrictions

### **Input Validation**
- ✅ Parameter sanitization
- ✅ Type-safe request handling
- ✅ Comprehensive error responses

## 📈 **Monitoring & Observability**

### **Built-in Ballerina Features**
- **Logging**: Structured logging with configurable levels
- **Metrics**: HTTP request/response metrics
- **Tracing**: Distributed tracing support
- **Health Checks**: Service health endpoints

### **WSO2 Integration**
- **API Manager Analytics**: Request analytics and reporting
- **Choreo Observability**: Cloud-native monitoring
- **ELK Stack**: Centralized logging with Elasticsearch

## 🤝 **Contributing**

### **Development Setup**
1. Fork the repository
2. Set up local environment with Ballerina
3. Create feature branch
4. Test with both backend and frontend
5. Submit pull request

### **Code Standards**
- Follow Ballerina coding conventions
- Add comprehensive error handling
- Include unit tests for new features
- Update documentation

## 📚 **Learn More**

### **WSO2 Resources**
- [Ballerina Documentation](https://ballerina.io/learn/)
- [WSO2 API Manager](https://wso2.com/api-manager/)
- [WSO2 Choreo Platform](https://wso2.com/choreo/)
- [Ballerina By Example](https://ballerina.io/learn/by-example/)

### **Project Resources**
- [OpenWeatherMap API](https://openweathermap.org/api)
- [React Documentation](https://react.dev/)
- [Tailwind CSS](https://tailwindcss.com/)

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- **WSO2** for the amazing Ballerina language and API management tools
- **OpenWeatherMap** for providing free weather data APIs
- **React Team** for the excellent frontend framework
- **Tailwind CSS** for the utility-first CSS framework

---

**Built with ❤️ using WSO2 Ballerina | Ready for WSO2 API Manager | Enterprise-Grade APIs**