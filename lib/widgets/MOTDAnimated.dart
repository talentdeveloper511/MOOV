import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/widgets/MOTD.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class TransitionsHomePage extends StatefulWidget {
  @override
  TransitionsHomePageState createState() => TransitionsHomePageState();
}

class TransitionsHomePageState extends State<TransitionsHomePage> {
  bool _slowAnimations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text('Material Transitions')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _TransitionListTile(
                  title: 'Container transform',
                  subtitle: 'OpenContainer',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return OpenContainerTransformDemo();
                        },
                      ),
                    );
                  },
                ),
                _TransitionListTile(
                  title: 'Fade',
                  subtitle: 'FadeScaleTransition',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return FadeScaleTransitionDemo();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 0.0),
          SafeArea(
            child: SwitchListTile(
              value: _slowAnimations,
              onChanged: (bool value) async {
                setState(() {
                  _slowAnimations = value;
                });
                // Wait until the Switch is done animating before actually slowing
                // down time.
                if (_slowAnimations) {
                  await Future<void>.delayed(const Duration(milliseconds: 300));
                }
                double timeDilation = _slowAnimations ? 20.0 : 1.0;
              },
              title: const Text('Slow animations'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransitionListTile extends StatelessWidget {
  const _TransitionListTile({
    this.onTap,
    this.title,
    this.subtitle,
  });

  final GestureTapCallback onTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      leading: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.black54,
          ),
        ),
        child: const Icon(
          Icons.play_arrow,
          size: 35,
        ),
      ),
      onTap: onTap,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class FadeScaleTransitionDemo extends StatefulWidget {
  @override
  _FadeScaleTransitionDemoState createState() =>
      _FadeScaleTransitionDemoState();
}

class _FadeScaleTransitionDemoState extends State<FadeScaleTransitionDemo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller = AnimationController();

  @override
  void initState() {
    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        setState(() {
          // setState needs to be called to trigger a rebuild because
          // the 'HIDE FAB'/'SHOW FAB' button needs to be updated based
          // the latest value of [_controller.status].
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isAnimationRunningForwardsOrComplete {
    switch (_controller.status) {
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return true;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade')),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return FadeScaleTransition(
            animation: _controller,
            child: child,
          );
        },
        child: Visibility(
          visible: _controller.status != AnimationStatus.dismissed,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(height: 0.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showModal<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _ExampleAlertDialog();
                      },
                    );
                  },
                  child: const Text('SHOW MODAL'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_isAnimationRunningForwardsOrComplete) {
                      _controller.reverse();
                    } else {
                      _controller.forward();
                    }
                  },
                  child: _isAnimationRunningForwardsOrComplete
                      ? const Text('HIDE FAB')
                      : const Text('SHOW FAB'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Alert Dialog'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('DISCARD'),
        ),
      ],
    );
  }
}

const double _fabDimension = 56.0;

/// The demo page for [OpenContainerTransform].
class OpenContainerTransformDemo extends StatefulWidget {
  @override
  _OpenContainerTransformDemoState createState() {
    return _OpenContainerTransformDemoState();
  }
}

class _OpenContainerTransformDemoState
    extends State<OpenContainerTransformDemo> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  void _showMarkedAsDoneSnackbar(bool isMarkedAsDone) {}

  void _showSettingsBottomModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 125,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fade mode',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 12),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(2.0),
                    selectedBorderColor: Theme.of(context).colorScheme.primary,
                    onPressed: (int index) {
                      setModalState(() {
                        setState(() {
                          _transitionType = index == 0
                              ? ContainerTransitionType.fade
                              : ContainerTransitionType.fadeThrough;
                        });
                      });
                    },
                    isSelected: <bool>[
                      _transitionType == ContainerTransitionType.fade,
                      _transitionType == ContainerTransitionType.fadeThrough,
                    ],
                    children: const <Widget>[
                      Text('FADE'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('FADE THROUGH'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          _OpenContainerWrapper(
            transitionType: _transitionType,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return _ExampleCardMOTD(openContainer: openContainer);
            },
            onClosed: _showMarkedAsDoneSnackbar,
          ),
          const SizedBox(height: 16.0),
          _OpenContainerWrapper(
            transitionType: _transitionType,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return _ExampleSingleTile(openContainer: openContainer);
            },
            onClosed: _showMarkedAsDoneSnackbar,
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return _SmallerCard(
                      openContainer: openContainer,
                      subtitle: 'Secondary text',
                    );
                  },
                  onClosed: _showMarkedAsDoneSnackbar,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return _SmallerCard(
                      openContainer: openContainer,
                      subtitle: 'Secondary text',
                    );
                  },
                  onClosed: _showMarkedAsDoneSnackbar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return _SmallerCard(
                      openContainer: openContainer,
                      subtitle: 'Secondary',
                    );
                  },
                  onClosed: _showMarkedAsDoneSnackbar,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return _SmallerCard(
                      openContainer: openContainer,
                      subtitle: 'Secondary',
                    );
                  },
                  onClosed: _showMarkedAsDoneSnackbar,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return _SmallerCard(
                      openContainer: openContainer,
                      subtitle: 'Secondary',
                    );
                  },
                  onClosed: _showMarkedAsDoneSnackbar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ...List<Widget>.generate(10, (int index) {
            return OpenContainer<bool>(
              transitionType: _transitionType,
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return PostDetail("hwrAgk600Wwo7nVGqeS6");
              },
              tappable: false,
              closedShape: const RoundedRectangleBorder(),
              closedElevation: 0.0,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return ListTile(
                  leading: Image.asset(
                    'assets/avatar_logo.png',
                    width: 40,
                  ),
                  onTap: openContainer,
                  title: Text('List item ${index + 1}'),
                  subtitle: const Text('Secondary text'),
                );
              },
            );
          }),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return PostDetail("hbOLKkMJLg9YSJeQA0fh");
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.secondary,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    @required this.closedBuilder,
    @required this.transitionType,
    @required this.onClosed,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return PostDetail("hwrAgk600Wwo7nVGqeS6");
      },
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return _ExampleCardMOTD(openContainer: openContainer);
      },
      onClosed: (bool isMarkedAsDone) {
        isMarkedAsDone = true;
      },
    );
  }
}

class _ExampleCardMOTD extends StatelessWidget {
  const _ExampleCardMOTD({@required this.openContainer});

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    return _InkWellOverlay(
        openContainer: openContainer, height: 300, child: MOTD());
  }
}

class _SmallerCard extends StatelessWidget {
  const _SmallerCard({
    @required this.openContainer,
    @required this.subtitle,
  });

  final VoidCallback openContainer;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _InkWellOverlay(
      openContainer: openContainer,
      height: 225,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.black38,
            height: 150,
            child: Center(
              child: Image.asset(
                'lib/assets/motd.jpg',
                width: 80,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleSingleTile extends StatelessWidget {
  const _ExampleSingleTile({@required this.openContainer});

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    const double height = 100.0;

    return _InkWellOverlay(
      openContainer: openContainer,
      height: height,
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.black38,
            height: height,
            width: height,
            child: Center(
              child: Image.asset(
                'lib/assets/motd.jpg',
                width: 60,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Lorem ipsum dolor sit amet, consectetur '
                      'adipiscing elit,',
                      style: Theme.of(context).textTheme.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback openContainer;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}

// class _DetailsPage extends StatelessWidget {
//   const _DetailsPage({this.includeMarkAsDoneButton = true});

//   final bool includeMarkAsDoneButton;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Details page'),
//         actions: <Widget>[
//           if (includeMarkAsDoneButton)
//             IconButton(
//               icon: const Icon(Icons.done),
//               onPressed: () => Navigator.pop(context, true),
//               tooltip: 'Mark as done',
//             )
//         ],
//       ),
//       body: ListView(
//         children: <Widget>[
//           Container(
//             color: Colors.black38,
//             height: 250,
//             child: Padding(
//               padding: const EdgeInsets.all(70.0),
//               child: Image.asset(
//                 'lib/assets/motd.jpg',
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   'Title',
//                   style: Theme.of(context).textTheme.headline5.copyWith(
//                         color: Colors.black54,
//                         fontSize: 30.0,
//                       ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "_loremIpsumParagraph",
//                   style: Theme.of(context).textTheme.bodyText2.copyWith(
//                         color: Colors.black54,
//                         height: 1.5,
//                         fontSize: 16.0,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
