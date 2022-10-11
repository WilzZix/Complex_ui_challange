import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF383838),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Stack(
            children: [
              const ArrowIcons(),
              const Plane(),
              const Line(),
              Positioned.fill(
                left: 32 + 8,
                child: Page(
                    number: '01',
                    question: 'what do you want?',
                    answers: const ['nothing', 'everything'],
                    optionSelected: () {
                      return;
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemFader extends StatefulWidget {
  const ItemFader({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _ItemFaderState createState() => _ItemFaderState();
}

class _ItemFaderState extends State<ItemFader>
    with SingleTickerProviderStateMixin {
  int position = 1;
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(
            0,
            64.0 * position * (1 - _animation.value),
          ),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
    );
  }

  void show() {
    setState(() => position = 1);
    _animationController.forward();
  }

  void hide() {
    setState(() => position = -1);
    _animationController.reverse();
  }
}

class Page extends StatefulWidget {
  const Page(
      {Key? key,
      required this.number,
      required this.question,
      required this.answers,
      required this.optionSelected})
      : super(key: key);
  final String number;
  final String question;
  final List<String> answers;
  final VoidCallback optionSelected;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  late List<GlobalKey<_ItemFaderState>> keys;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keys = List.generate(
      5,
      (_) => GlobalKey<_ItemFaderState>(),
    );
    onInit();
  }

  void onInit() async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(const Duration(milliseconds: 40));
      key.currentState?.show();
    }
  }

  void onTap() async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(const Duration(milliseconds: 40));
      key.currentState?.hide();
    }
    widget.optionSelected();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        ItemFader(key: keys[0], child: StepNumber(number: widget.number)),
        ItemFader(key: keys[1], child: StepQuestion(question: widget.question)),
        const Spacer(),
        ...widget.answers.map((String e) {
          int answerIndex = widget.answers.indexOf(e);
          int keyIndex = answerIndex + 2;
          return ItemFader(
              key: keys[keyIndex],
              child: OptionItem(name: e, onTap: widget.optionSelected));
        }),
        const SizedBox(
          height: 64,
        ),
      ],
    );
  }
}

class StepQuestion extends StatelessWidget {
  const StepQuestion({Key? key, required this.question}) : super(key: key);
  final String question;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StepNumber extends StatelessWidget {
  const StepNumber({Key? key, required this.number}) : super(key: key);
  final String number;

  @override
  Widget build(BuildContext context) {
    return Text(
      number,
      style: const TextStyle(fontSize: 25),
    );
  }
}

class OptionItem extends StatefulWidget {
  const OptionItem({Key? key, required this.name, required this.onTap})
      : super(key: key);
  final String name;
  final VoidCallback onTap;

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            const SizedBox(
              width: 26,
            ),
            const Dot(),
            const SizedBox(
              width: 26,
            ),
            Expanded(
              child: Text(
                widget.name,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 40 + 32,
      top: 40,
      bottom: 0,
      width: 1,
      child: Container(
        color: Colors.white.withOpacity(
          0.5,
        ),
      ),
    );
  }
}

class Plane extends StatelessWidget {
  const Plane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 40,
      top: 32,
      child: RotatedBox(
        quarterTurns: 2,
        child: Icon(
          Icons.airplanemode_active,
          size: 64,
        ),
      ),
    );
  }
}

class ArrowIcons extends StatelessWidget {
  const ArrowIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      bottom: 0,
      child: Column(
        children: const [
          IconUp(),
          IconDown(),
        ],
      ),
    );
  }
}

class IconUp extends StatelessWidget {
  const IconUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.arrow_upward),
    );
  }
}

class IconDown extends StatelessWidget {
  const IconDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.arrow_downward),
    );
  }
}
