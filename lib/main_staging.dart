import 'package:fairway/app/app.dart';
import 'package:fairway/bootstrap.dart';
import 'package:fairway/config/flavor_config.dart';

void main() {
  FlavorConfig(flavor: Flavor.staging);
  bootstrap(() => const App());
}
