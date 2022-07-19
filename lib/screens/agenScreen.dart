import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:sampark/utils/prefs.dart';
import 'package:sampark/widgets/pendingLoans.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({Key? key}) : super(key: key);

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  String? empcode;

  @override
  void initState() {
    empcode = UserSimplePreferences.getUsername() ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 197, 201, 207),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Hey ${empcode ?? 'No Name'} ,',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26)),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 22),
                                child: Text(greetings(),
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 45,
                            height: 45,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              'https://picsum.photos/seed/907/600',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Home(title: 'Sampark', page: 3)));
                   */
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.user,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Add New')
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.inbox,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Doc Upload')
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.wallet,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Payments')
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.note,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Reports')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
                    child: Container(
                      width: size.width,
                      height: double.infinity,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.indigo[400],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.8),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: PendingLoans(empcode: empcode.toString()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String greetings() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 17) {
    return 'Good Afternoon';
  }
  return 'Good Evening';
}
