import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/goal_provider.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  double _targetMinutes = 60;
  bool _hasTarget = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text('New Goal', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            'What would you\nlike to track?',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Input Field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _titleController,
                              style: GoogleFonts.poppins(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: 'e.g. Reading, Gym, Coding',
                                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(20),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 48),
                          Text(
                            'Daily Target',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Toggle & Slider Container
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.timer_outlined, color: Colors.grey.shade600),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Set time goal',
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    Switch.adaptive(
                                      value: _hasTarget,
                                      activeColor: const Color(0xFF6B4EFF),
                                      onChanged: (val) {
                                        setState(() {
                                          _hasTarget = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),

                                if (_hasTarget) ...[
                                  const Divider(height: 32),
                                  Text(
                                    '${_targetMinutes.toInt()} min',
                                    style: GoogleFonts.poppins(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6B4EFF),
                                    ),
                                  ),
                                  Slider(
                                    value: _targetMinutes,
                                    min: 5,
                                    max: 240,
                                    divisions: 47,
                                    activeColor: const Color(0xFF6B4EFF),
                                    onChanged: (val) => setState(() => _targetMinutes = val),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: FilledButton(
                              onPressed: _saveGoal,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E1E1E),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Create Goal',
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(goalsProvider.notifier).addGoal(
        _titleController.text,
        _hasTarget ? _targetMinutes.toInt() : null,
      );
      if (mounted) context.pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
