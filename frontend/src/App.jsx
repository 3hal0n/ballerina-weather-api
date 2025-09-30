import React, { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [city, setCity] = useState('')
  const [weather, setWeather] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [recentSearches, setRecentSearches] = useState([])

  // Load recent searches from localStorage on component mount
  useEffect(() => {
    const saved = localStorage.getItem('recentSearches')
    if (saved) {
      setRecentSearches(JSON.parse(saved))
    }
  }, [])

  // Save recent searches to localStorage
  const saveRecentSearch = (cityName) => {
    const updated = [cityName, ...recentSearches.filter(c => c !== cityName)].slice(0, 5)
    setRecentSearches(updated)
    localStorage.setItem('recentSearches', JSON.stringify(updated))
  }

  // Fetch weather data from Ballerina API
  const fetchWeather = async (cityName) => {
    if (!cityName.trim()) {
      setError('Please enter a city name')
      return
    }

    setLoading(true)
    setError('')
    
    try {
      const response = await fetch(`http://localhost:8080/weather/current?city=${encodeURIComponent(cityName)}`)
      const data = await response.json()
      
      if (response.ok) {
        setWeather(data)
        console.log('Weather data received:', data) // Debug log
        console.log('Temperature type:', typeof data.temperature, 'Value:', data.temperature) // Debug log
        saveRecentSearch(cityName)
      } else {
        setError(data.message || 'Failed to fetch weather data')
        setWeather(null)
      }
    } catch (err) {
      setError('Unable to connect to weather service. Make sure the Ballerina API is running on port 8080.')
      setWeather(null)
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    fetchWeather(city)
  }

  const handleRecentSearch = (cityName) => {
    setCity(cityName)
    fetchWeather(cityName)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-400 via-blue-500 to-blue-600">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-6xl font-bold text-white mb-2">
            Weather App
          </h1>
          <p className="text-blue-100 text-lg">
            Get current weather information for any city
          </p>
        </div>

        {/* Search Form */}
        <div className="max-w-md mx-auto mb-8">
          <form onSubmit={handleSubmit} className="flex gap-2">
            <input
              type="text"
              value={city}
              onChange={(e) => setCity(e.target.value)}
              placeholder="Enter city name..."
              className="flex-1 px-4 py-3 rounded-lg border-0 text-gray-700 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-300 text-lg"
              disabled={loading}
            />
            <button
              type="submit"
              disabled={loading}
              className="px-6 py-3 bg-white text-blue-600 rounded-lg font-semibold hover:bg-blue-50 focus:outline-none focus:ring-2 focus:ring-blue-300 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? '...' : 'Search'}
            </button>
          </form>
        </div>

        {/* Recent Searches */}
        {recentSearches.length > 0 && (
          <div className="max-w-md mx-auto mb-8">
            <p className="text-blue-100 text-sm mb-2">Recent searches:</p>
            <div className="flex flex-wrap gap-2">
              {recentSearches.map((recentCity, index) => (
                <button
                  key={index}
                  onClick={() => handleRecentSearch(recentCity)}
                  className="px-3 py-1 bg-blue-200 text-blue-800 rounded-full text-sm hover:bg-blue-300 transition-colors"
                >
                  {recentCity}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Loading Spinner */}
        {loading && (
          <div className="text-center mb-8">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-white"></div>
            <p className="text-white mt-2">Fetching weather data...</p>
          </div>
        )}

        {/* Error Message */}
        {error && (
          <div className="max-w-md mx-auto mb-8">
            <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg">
              <p className="font-semibold">Error:</p>
              <p>{error}</p>
            </div>
          </div>
        )}

        {/* Weather Card */}
        {weather && !loading && (
          <div className="max-w-md mx-auto">
            <div className="bg-white rounded-2xl shadow-xl p-6 text-center">
              <h2 className="text-2xl font-bold text-gray-800 mb-2">
                {weather.city}
              </h2>
              <div className="mb-4">
                <span className="text-5xl font-bold text-blue-600">
                  {typeof weather.temperature === 'number' && !isNaN(weather.temperature) 
                    ? Math.round(weather.temperature) 
                    : 'N/A'}°C
                </span>
              </div>
              <p className="text-gray-600 text-lg capitalize mb-4">
                {weather.description}
              </p>
              <div className="border-t pt-4">
                <p className="text-sm text-gray-500">
                  Temperature in Celsius
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Instructions */}
        {!weather && !loading && !error && (
          <div className="max-w-md mx-auto text-center">
            <div className="bg-blue-500 bg-opacity-20 rounded-lg p-6 text-white">
              <h3 className="text-lg font-semibold mb-2">How to use:</h3>
              <ol className="text-left text-sm space-y-1">
                <li>1. Make sure the Ballerina weather service is running on port 8080</li>
                <li>2. Enter a city name in the search box</li>
                <li>3. Click "Search" to get current weather information</li>
              </ol>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

export default App
