import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/providers.dart';
import '../../domain/entities/alert_rule.dart';

class AlertRulesPage extends ConsumerWidget {
  const AlertRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesState = ref.watch(alertRulesVmProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Rules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddRuleDialog(context, ref),
          ),
        ],
      ),
      body: rulesState.when(
        data: (rules) {
          // Show message when no rules
          if (rules.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No alert rules configured'),
                  SizedBox(height: 8),
                  Text('Tap + to create a new rule', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rules.length,
            itemBuilder: (context, index) {
              final rule = rules[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    _getRuleIcon(rule.ruleType),
                    color: rule.isEnabled ? Colors.blue : Colors.grey,
                  ),
                  title: Text(rule.name),
                  subtitle: Text(rule.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Switch to turn rule on/off
                      Switch(
                        value: rule.isEnabled,
                        onChanged: (value) {
                          ref.read(alertRulesVmProvider.notifier).toggleRule(rule.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showEditRuleDialog(context, ref, rule);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.read(alertRulesVmProvider.notifier).deleteRule(rule.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Rule deleted')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  IconData _getRuleIcon(String type) {
    switch (type) {
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'windSpeed':
        return Icons.air;
      case 'rainProbability':
        return Icons.umbrella;
      default:
        return Icons.notifications;
    }
  }

  void _showEditRuleDialog(BuildContext context, WidgetRef ref, AlertRule rule) {
    final nameController = TextEditingController(text: rule.name);
    final thresholdController = TextEditingController(text: rule.threshold.toString());
    String selectedType = rule.ruleType;
    String selectedOperator = rule.operator;
    bool notifyOnTrigger = rule.notifyOnTrigger;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Alert Rule'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Rule Name',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Condition Type'),
                  items: const [
                    DropdownMenuItem(value: 'temperature', child: Text('Temperature')),
                    DropdownMenuItem(value: 'humidity', child: Text('Humidity')),
                    DropdownMenuItem(value: 'windSpeed', child: Text('Wind Speed')),
                    DropdownMenuItem(value: 'rainProbability', child: Text('Rain Probability')),
                  ],
                  onChanged: (value) {
                    setState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedOperator,
                        decoration: const InputDecoration(labelText: 'Operator'),
                        items: const [
                          DropdownMenuItem(value: '>', child: Text('>')),
                          DropdownMenuItem(value: '<', child: Text('<')),
                          DropdownMenuItem(value: '>=', child: Text('>=')),
                          DropdownMenuItem(value: '<=', child: Text('<=')),
                          DropdownMenuItem(value: '==', child: Text('==')),
                        ],
                        onChanged: (value) {
                          setState(() => selectedOperator = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: thresholdController,
                        decoration: InputDecoration(
                          labelText: 'Threshold',
                          hintText: _getThresholdHint(selectedType),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Send Notification'),
                  value: notifyOnTrigger,
                  onChanged: (value) {
                    setState(() => notifyOnTrigger = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || thresholdController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                final threshold = double.tryParse(thresholdController.text);
                if (threshold == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid threshold value')),
                  );
                  return;
                }
                final updatedRule = AlertRule(
                  id: rule.id,
                  name: nameController.text,
                  ruleType: selectedType,
                  operator: selectedOperator,
                  threshold: threshold,
                  isEnabled: rule.isEnabled,
                  notifyOnTrigger: notifyOnTrigger,
                  createdAt: rule.createdAt,
                );
                await ref.read(alertRulesVmProvider.notifier).updateRule(updatedRule);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rule updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
  void _showAddRuleDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final thresholdController = TextEditingController();
    String selectedType = 'temperature';
    String selectedOperator = '>';
    bool notifyOnTrigger = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Alert Rule'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Rule Name',
                    hintText: 'e.g., High Temperature Alert',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Condition Type'),
                  items: const [
                    DropdownMenuItem(value: 'temperature', child: Text('Temperature')),
                    DropdownMenuItem(value: 'humidity', child: Text('Humidity')),
                    DropdownMenuItem(value: 'windSpeed', child: Text('Wind Speed')),
                    DropdownMenuItem(value: 'rainProbability', child: Text('Rain Probability')),
                  ],
                  onChanged: (value) {
                    setState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedOperator,
                        decoration: const InputDecoration(labelText: 'Operator'),
                        items: const [
                          DropdownMenuItem(value: '>', child: Text('>')),
                          DropdownMenuItem(value: '<', child: Text('<')),
                          DropdownMenuItem(value: '>=', child: Text('>=')),
                          DropdownMenuItem(value: '<=', child: Text('<=')),
                          DropdownMenuItem(value: '==', child: Text('==')),
                        ],
                        onChanged: (value) {
                          setState(() => selectedOperator = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: thresholdController,
                        decoration: InputDecoration(
                          labelText: 'Threshold',
                          hintText: _getThresholdHint(selectedType),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Send Notification'),
                  value: notifyOnTrigger,
                  onChanged: (value) {
                    setState(() => notifyOnTrigger = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || thresholdController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final threshold = double.tryParse(thresholdController.text);
                if (threshold == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid threshold value')),
                  );
                  return;
                }

                final rule = AlertRule(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  ruleType: selectedType,
                  operator: selectedOperator,
                  threshold: threshold,
                  isEnabled: true,
                  notifyOnTrigger: notifyOnTrigger,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                );

                ref.read(alertRulesVmProvider.notifier).addRule(rule);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rule created')),
                );
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  String _getThresholdHint(String type) {
    switch (type) {
      case 'temperature':
        return 'e.g., 35';
      case 'humidity':
        return 'e.g., 80';
      case 'windSpeed':
        return 'e.g., 15';
      case 'rainProbability':
        return 'e.g., 70';
      default:
        return '';
    }
  }
}
