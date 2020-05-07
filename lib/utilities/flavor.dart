enum Flavor {
  development,
  production
}

class FlavorConfig {
  final String endPoint;
  final Flavor flavor;

  FlavorConfig(this.endPoint, this.flavor);
}

FlavorConfig flavorDev = FlavorConfig("https://laundroll-dev.azurewebsites.net", Flavor.development);

FlavorConfig flavorProduction = FlavorConfig("https://dobilink-svc.azurewebsites.net", Flavor.production);