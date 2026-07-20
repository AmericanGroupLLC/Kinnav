import 'package:flutter/material.dart';
import '../models/guardian.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';

/// A lightweight support / talk-to-someone chat, echoing the "Hi there! I'm here
/// to help" experience from the reference screens.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<_Msg> _messages = [
    _Msg('Hi there! I\'m here to help 💜', fromMe: false),
    _Msg('You\'re not alone — a guardian is always a tap away.', fromMe: false),
  ];

  static const _quickReplies = [
    'I need someone to talk to',
    'Help me verify my profile',
    'How do guardians work?',
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Msg(text, fromMe: true));
      _messages.add(_Msg(
        'Thank you for reaching out. A guardian typically replies in under 5 minutes. 💜',
        fromMe: false,
      ));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final helpers = kGuardians.take(3).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _Header(helpers: helpers),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final m in _messages) _Bubble(msg: m),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final q in _quickReplies)
                      GestureDetector(
                        onTap: () => _send(q),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lavenderCard,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(q,
                              style: const TextStyle(
                                  color: AppColors.primaryDark)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          _Composer(controller: _controller, onSend: () => _send(_controller.text)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final List<Guardian> helpers;
  const _Header({required this.helpers});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Safer Support',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < helpers.length; i++)
                    Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 12),
                      child: Column(
                        children: [
                          InitialsAvatar(
                            initials: helpers[i].initials,
                            color: helpers[i].color,
                            size: 56,
                            borderWidth: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(helpers[i].name.split(' ').first,
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Typically replies in under 5m',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: msg.fromMe ? AppColors.primary : AppColors.lavenderCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.fromMe ? Colors.white : AppColors.textDark,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _Composer({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  filled: true,
                  fillColor: AppColors.lavenderBg,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onSend,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool fromMe;
  _Msg(this.text, {required this.fromMe});
}
