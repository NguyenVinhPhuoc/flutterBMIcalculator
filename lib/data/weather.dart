class Weather {
  String name = '';
  String description = '';
  double temparture = 0;
  double perceived = 0;
  double pressure = 0;
  double humidity = 0;

  Weather(this.name, this.description, this.temparture, this.perceived,
      this.pressure, this.humidity);

  Weather.fromJson(Map<String, dynamic> weatherMap) {
    this.name = weatherMap['name'];
    // this.temparture = (weatherMap['main']['temp'] * (9 / 5) - 459.67) ?? 0;
    this.temparture = (weatherMap['main']['temp'] - 273.15) ?? 0;
    this.pressure = (weatherMap['main']['pressure'] - 273.15) ?? 0;
    this.humidity = (weatherMap['main']['humidity'] - 273.15) ?? 0;
    this.description = weatherMap['weather'][0]['main'] ?? '';
    this.perceived = weatherMap['main']['feels_like'];
  }
}
