// Configuration for different environments
const config = {
  development: {
    API_URL: 'http://localhost:8080',
    API_TIMEOUT: 30000,
    CACHE_DURATION: 5 * 60 * 1000, // 5 minutes
  },
  production: {
    API_URL: import.meta.env.VITE_API_URL || 'https://your-production-api.com',
    API_TIMEOUT: 10000,
    CACHE_DURATION: 10 * 60 * 1000, // 10 minutes
  },
  test: {
    API_URL: 'http://localhost:8080',
    API_TIMEOUT: 5000,
    CACHE_DURATION: 1000, // 1 second
  }
};

const environment = import.meta.env.MODE || 'development';

export default config[environment];
export { environment };