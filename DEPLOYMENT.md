# 🚀 Deployment Guide - Weather API with WSO2 Ballerina

This guide provides step-by-step instructions for deploying the Weather API service and React frontend across different environments.

## 📋 **Prerequisites**

### **For All Deployments:**
- OpenWeatherMap API key
- Git repository access
- Basic understanding of command line tools

### **Environment-Specific:**
- **Local**: Ballerina, Node.js
- **Docker**: Docker, Docker Compose
- **Cloud**: Cloud provider account (AWS, Azure, GCP)
- **WSO2**: WSO2 Choreo account

## 🏠 **Local Development Deployment**

### **Backend (Ballerina Service)**

1. **Setup Environment**
   ```bash
   # Install Ballerina Swan Lake (if not installed)
   # Download from: https://ballerina.io/downloads/
   
   # Verify installation
   bal version
   ```

2. **Configure API Key**
   ```bash
   # Create .env file
   echo "OPENWEATHER_API_KEY=your_actual_api_key_here" > .env
   
   # OR set environment variable
   $env:OPENWEATHER_API_KEY="your_actual_api_key_here"  # PowerShell
   export OPENWEATHER_API_KEY="your_actual_api_key_here"  # Bash
   ```

3. **Build and Run**
   ```bash
   # Build the project
   bal build
   
   # Run the service
   .\start-service.ps1  # Windows
   # OR
   bal run
   ```

4. **Verify Backend**
   ```bash
   # Test the API
   curl "http://localhost:8080/weather/current?city=London"
   ```

### **Frontend (React App)**

1. **Setup Dependencies**
   ```bash
   cd frontend
   npm install
   ```

2. **Configure API Endpoint** (if needed)
   ```javascript
   // In frontend/src/App.jsx - update API URL for production
   const API_BASE_URL = process.env.VITE_API_URL || 'http://localhost:8080';
   ```

3. **Build and Run**
   ```bash
   # Development server
   npm run dev
   
   # Production build
   npm run build
   npm run preview
   ```

4. **Verify Frontend**
   - Open http://localhost:5173 (dev) or http://localhost:4173 (preview)
   - Test weather search functionality

## ⚡ Option A — Vercel (frontend) + Render / Railway (backend) (recommended)

This repository uses a serverless/static-first approach for the frontend and a managed service for the backend. This option minimizes ops work and is ideal for rapid deployment and easy maintenance.

### Frontend — Vercel

1. Push your repository to GitHub (ensure `frontend/` is present).
2. Create a Vercel account and import the repo.
3. When configuring the project on Vercel:
    - Set the root directory to `frontend` (if deploying only the frontend folder).
    - Build command: `npm run build`
    - Output directory: `dist`
    - Add environment variables for the frontend build (if needed):
       - `VITE_API_URL` — URL of the deployed backend (Render/Railway URL)
4. Deploy — Vercel will build and serve the app on a global CDN.

Notes:
- Client-side environment variables must be prefixed with `VITE_` to be exposed at build time.
- If you need server-side functionality for the frontend (SSR), Vercel supports serverless functions. For this app, static hosting is sufficient.

### Backend — Render (recommended) or Railway

Render and Railway are excellent managed platforms for small services with automatic deploys, health checks, and easy secrets management.

**Render (recommended)**

1. Create a Render account and connect your GitHub repository.
2. Create a new **Web Service**:
    - Use the repo root as the code location.
    - Choose **Docker** (if you have a Dockerfile) or use the **Build Command** `bal build` and **Start Command** `bal run`.
    - Add environment variables and secrets: `OPENWEATHER_API_KEY`.
    - Set a health check path: `/health/ready`.
3. Render will build and give you an HTTPS URL for the service.

**Railway (simpler dev flow)**

1. Create a Railway project and add a service linked to the repository.
2. Use build commands (`bal build`) and start commands (`bal run`) or Docker if preferred.
3. Add `OPENWEATHER_API_KEY` as an environment variable in the Railway dashboard.

Notes:
- Render offers production features such as pinned IPs and more advanced health checks if required.
- Railway is quick for prototypes and dev environments.

### Linking Frontend & Backend

1. After backend is deployed, copy the HTTPS URL and set `VITE_API_URL` in Vercel's project environment variables.
2. Re-deploy the frontend in Vercel (or trigger an automatic deploy) so the build embeds the production API URL.
3. Test end-to-end: open the Vercel URL and search for a city.

### Post-deploy checks

- Verify backend health endpoints:
   ```bash
   curl https://your-backend.onrender.com/health/ready
   curl https://your-backend.onrender.com/health/live
   ```
- Verify frontend is using the correct API URL and CORS is allowed for the frontend domain.


## ☁️ Other Cloud Deployment Options (brief)

If you want more control or need advanced infra features, you can deploy containers to Cloud Run (GCP), ECS/Fargate (AWS), or Azure Container Instances. These are production-ready choices but require more operational work compared to Render/Railway.

For production-grade deployments consider:
- Cloud Run (GCP): serverless containers with automatic scaling and HTTPS
- ECS/Fargate (AWS): more control over networking and IAM
- Kubernetes (EKS/GKE/AKS): full control for complex deployments

Use the Docker-based steps if you plan to move to these environments later. For this project, Option A (Vercel + Render/Railway) gives the fastest, lowest-ops path to production.

## 🏢 **WSO2 Choreo Deployment (Recommended)**

### **Backend Deployment**

1. **Prepare Choreo Configuration**
   ```yaml
   # .choreo/endpoints.yaml
   version: 0.1
   endpoints:
     - name: weather-api
       port: 8080
       type: REST
       networkVisibility: Project
       context: /weather
   ```

2. **Deploy to Choreo**
   ```bash
   # Connect to Choreo
   choreo login
   
   # Create project
   choreo project create weather-api
   
   # Deploy
   choreo deploy --env dev
   choreo deploy --env prod
   ```

### **Frontend Deployment**

1. **Configure for Choreo Backend**
   ```javascript
   // frontend/src/config.js
   const config = {
     development: {
       API_URL: 'http://localhost:8080'
     },
     production: {
       API_URL: 'https://your-choreo-endpoint.choreoapis.dev'
     }
   };
   
   export default config[process.env.NODE_ENV || 'development'];
   ```

2. **Deploy Frontend to Netlify/Vercel**
   ```bash
   # Netlify
   npm run build
   netlify deploy --prod --dir=dist
   
   # Vercel
   npm run build
   vercel --prod
   ```

## 🔒 **Production Security Improvements**

### **Backend Security Enhancements**

1. **Add Authentication**
   ```ballerina
   import ballerina/jwt;
   
   @http:ServiceConfig {
       auth: [
           {
               jwtValidatorConfig: {
                   issuer: "https://your-auth-server.com",
                   audience: "weather-api"
               }
           }
       ]
   }
   service /weather on new http:Listener(8080) {
       // Protected endpoints
   }
   ```

2. **Rate Limiting**
   ```ballerina
   import ballerina/cache;
   
   // Add rate limiting logic
   cache:Cache rateLimitCache = new(capacity = 1000, evictionFactor = 0.2);
   ```

3. **Input Validation**
   ```ballerina
   import ballerina/constraint;
   
   type CityRequest record {
       @constraint:String {minLength: 1, maxLength: 100}
       string city;
   };
   ```

### **Frontend Security Enhancements**

1. **Environment Configuration**
   ```javascript
   // frontend/.env.production
   VITE_API_URL=https://your-production-api.com
   VITE_APP_VERSION=1.0.0
   ```

2. **Content Security Policy**
   ```html
   <!-- In index.html -->
   <meta http-equiv="Content-Security-Policy" 
         content="default-src 'self'; connect-src 'self' https://your-api.com;">
   ```

## ⚡ **Performance Improvements**

### **Backend Optimizations**

1. **Add Caching**
   ```ballerina
   import ballerina/cache;
   
   cache:Cache weatherCache = new(capacity = 100, evictionFactor = 0.2, 
                                   defaultMaxAge = 300); // 5 minutes
   ```

2. **Connection Pooling**
   ```ballerina
   http:ClientConfiguration clientConfig = {
       poolConfig: {
           maxActiveConnections: 50,
           maxIdleConnections: 25,
           waitTimeInMillis: 60000
       }
   };
   http:Client openWeatherClient = check new (OPENWEATHER_BASE_URL, clientConfig);
   ```

3. **Health Check Endpoint**
   ```ballerina
   service /health on new http:Listener(8081) {
       resource function get status() returns json {
           return {
               "status": "UP",
               "timestamp": time:utcNow(),
               "service": "weather-api",
               "version": "1.0.0"
           };
       }
   }
   ```

### **Frontend Optimizations**

1. **Code Splitting**
   ```javascript
   // Lazy load components
   const WeatherCard = lazy(() => import('./components/WeatherCard'));
   ```

2. **Service Worker for Caching**
   ```javascript
   // public/sw.js
   const CACHE_NAME = 'weather-app-v1';
   const urlsToCache = [
       '/',
       '/static/css/',
       '/static/js/'
   ];
   ```

3. **Bundle Optimization**
   ```javascript
   // vite.config.js
   export default {
       build: {
           rollupOptions: {
               output: {
                   manualChunks: {
                       vendor: ['react', 'react-dom'],
                       ui: ['tailwindcss']
                   }
               }
           }
       }
   }
   ```

## 📊 **Monitoring & Observability**

### **Application Monitoring**

1. **Add Structured Logging**
   ```ballerina
   import ballerina/log;
   import ballerina/uuid;
   
   // Add correlation ID
   string correlationId = uuid:createType4AsString();
   log:printInfo("Weather request", city = city, correlationId = correlationId);
   ```

2. **Metrics Collection**
   ```ballerina
   import ballerina/observe;
   
   @observe:Observable
   public function fetchWeatherData(string city) returns json|error {
       // Automatically tracked for metrics
   }
   ```

3. **Health Checks with Dependencies**
   ```ballerina
   service /health on new http:Listener(8081) {
       resource function get live() returns json {
           return {"status": "UP"};
       }
       
       resource function get ready() returns json|error {
           // Check external dependencies
           http:Response|error response = openWeatherClient->get("/?q=test");
           if response is error {
               return error("External API not available");
           }
           return {"status": "READY"};
       }
   }
   ```

## 🔄 **CI/CD Pipeline**

### **GitHub Actions Example**

```yaml
# .github/workflows/deploy.yml
name: Deploy Weather API

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Ballerina
        uses: ballerina-platform/setup-ballerina@v1.1.0
        with:
          version: 2201.8.0
      - name: Run tests
        run: bal test

  deploy-backend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Choreo
        run: |
          choreo login --token ${{ secrets.CHOREO_TOKEN }}
          choreo deploy --env prod

  deploy-frontend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
      - name: Build and deploy
        run: |
          cd frontend
          npm ci
          npm run build
          npm run deploy
```

## 📋 **Deployment Checklist**

### **Pre-Deployment**
- [ ] API key configured securely
- [ ] CORS settings updated for production domains
- [ ] Health check endpoints implemented
- [ ] Error handling tested
- [ ] Performance testing completed
- [ ] Security review passed

### **Production Deployment**
- [ ] HTTPS enabled
- [ ] Monitoring and alerting configured
- [ ] Backup and recovery plan in place
- [ ] Load balancing configured (if needed)
- [ ] CDN setup for frontend (if needed)
- [ ] Database connections secured (if applicable)

### **Post-Deployment**
- [ ] Smoke tests passed
- [ ] Monitoring dashboards configured
- [ ] Documentation updated
- [ ] Team notified of deployment
- [ ] Rollback plan verified

This comprehensive deployment guide covers all major deployment scenarios and includes essential improvements for production readiness.