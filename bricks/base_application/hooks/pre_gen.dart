import 'dart:convert';
import 'package:http/http.dart';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  Progress progress = context.logger.progress('Parsing project name...');
  String name = context.vars['name'];
  context.vars['name'] = parseName(name);
  progress.complete('Project name parsed to ${context.vars['name']}');
  progress = context.logger.progress('Fetching latest version of serinus package...');
  try{
    context.vars['serinus_version'] = await getSerinusVersion();
  }catch(e){
    progress.fail('Failed to fetch latest version of serinus package');
    rethrow;
  }
  progress.complete();
}

String parseName(String name) {
  if(name.contains(' ')){
    return name.split(' ').join('_');
  }
  if(name.contains('-')){
    return name.split('-').join('_');
  }
  return name.toLowerCase();
}

Future<String> getSerinusVersion() async {
  final client = Client();
  final res = await client.get(Uri.parse('https://pub.dev/api/packages/serinus'));
  if(res.statusCode != 200){
    throw Exception('Failed to fetch serinus package');
  }
  final body = res.body;
  final package = jsonDecode(body);
  final version = package['latest']['version'];
  return version;
}
