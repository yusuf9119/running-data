#first name column
#last name colmn
#renaming division into gender
#need to change the city name to lat long


import pandas as pd

from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut
from geopy.extra.rate_limiter import RateLimiter


df = pd.read_csv('running.csv')


#first and last name columns
df2 = df.dropna(axis=1)
df2['fullname'] = df2['First'] + '' + df2['Last'] 


#time

df2['Time'] = pd.to_timedelta(df2['Time'])

df2['Total_Minutes'] = df2['Time'].et.total_seconds() /60
df2['Total_Minutes'] = df2['Total_Minutes'].round().astype(int)


#renaming division into gender

df2.rename(columns={'Division':'Gender'}, inplace = True)


def get_lat_long(city,state):
    address = f"{city}, {state}" 
    try:
        geolocator = Nominatim(user_agent='running', timeout=10)
        location = geolocator.geocode(address)
        if location:
            return location.latitude, location.longitude
        else:
            return None, None
    except GeocoderTimedOut:
        return None, None
    

df2['latitude'],df2['longitude'] = zip(*df2.apply(lambda x: get_lat_long(x['City'], x['State']), axis=1))

df2['latlong'] = df2['latitude'].astype(str) + ',' +  df2['longitude'].astype(str)

df2.to_csv('cleanedupRUNNING.CSV', index=False)
