/// This module is a representation of the entrypoint of your plugin.
/// It is the main class that will be used to register your plugin with the application.
/// 
/// This module should extend the [Module] class and override the [registerAsync] method.
/// 
/// You can also use the constructor to initialize any dependencies that your plugin may have.
class {{name.pascalCase}}Module extends Module {
  
  {{name.pascalCase}}Module();

  @override
  Future<Module> registerAsync(ApplicationConfig config) async {
    return this;
  }

}