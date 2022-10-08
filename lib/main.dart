import 'package:animate/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animation Showcase',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Scaffold(body: Center(child: HomeWidget())),
    );
  }
}

class HomeWidget extends ConsumerWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationStep = ref.watch(animationProvider);
    if (animationStep.value == null) {
      return const SizedBox.shrink();
    } else {
      final step = animationStep.value!;
      return TextButton(
        onPressed: () {
          ref.read(reset.notifier).state = DateTime.now().millisecondsSinceEpoch;
        },
        child: Container(
          decoration: BoxDecoration(
              color: step.color ?? Colors.red, borderRadius: step.borderRadius ?? BorderRadius.circular(30)),
          width: step.width ?? 120,
          height: step.height ?? 120,
          transform: step.transform ?? Matrix4.identity(),
          transformAlignment: Alignment.center,
        ),
      );
    }
  }
}
