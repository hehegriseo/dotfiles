#!/usr/bin/env bash
# Fetches weather from wttr.in and outputs JSON for waybar custom/weather

CITY="${WEATHER_CITY:-}"  # set WEATHER_CITY in env, or leave blank for auto-detect

API_URL="https://wttr.in/${CITY}?format=j1"

data=$(curl -sf --max-time 5 "$API_URL") || {
  echo '{"text": "󰅟 N/A", "tooltip": "Weather unavailable", "class": "unavailable"}'
  exit 0
}

condition=$(echo "$data" | python3 -c "
import json, sys
d = json.load(sys.stdin)
desc = d['current_condition'][0]['weatherDesc'][0]['value']
temp_c = d['current_condition'][0]['temp_C']
feels_c = d['current_condition'][0]['FeelsLikeC']
humidity = d['current_condition'][0]['humidity']
wind = d['current_condition'][0]['windspeedKmph']
max_t = d['weather'][0]['maxtempC']
min_t = d['weather'][0]['mintempC']

icons = {
    'Sunny': '󰖙', 'Clear': '󰖙', 'Partly cloudy': '󰖕', 'Cloudy': '󰖐',
    'Overcast': '󰖐', 'Mist': '󰖑', 'Fog': '󰖑', 'Freezing fog': '󰖑',
    'Patchy rain': '󰖗', 'Light rain': '󰖗', 'Moderate rain': '󰖗',
    'Heavy rain': '󰖘', 'Thunder': '󰖓', 'Thunderstorm': '󰖓',
    'Blizzard': '󰖒', 'Snow': '󰖘', 'Sleet': '󰖒', 'Blowing snow': '󰖒'
}
icon = next((v for k, v in icons.items() if k.lower() in desc.lower()), '󰖐')

text = f'{icon} {temp_c}°C'
tooltip = f'{desc}\n🌡 Feels like {feels_c}°C\n💧 Humidity {humidity}%\n💨 Wind {wind} km/h\n⬆ {max_t}° / ⬇ {min_t}°'

print(f'{text}|{tooltip}')
")

echo "$condition" | python3 -c "
import json, sys
line = sys.stdin.read().strip()
text, tooltip = line.split('|', 1)
print(json.dumps({'text': text, 'tooltip': tooltip, 'class': 'weather'}))
"
