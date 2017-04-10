Geocoder.configure(
  ip_lookup: :maxmind,
  maxmind: { service: :city_isp_org },
  timeout: 5
)
