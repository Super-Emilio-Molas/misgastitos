import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const MisGastitosApp());
}

class MisGastitosApp extends StatelessWidget {
  const MisGastitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis gastitos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          primary: AppColors.green,
          secondary: AppColors.orange,
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w900),
          headlineMedium: TextStyle(fontWeight: FontWeight.w900),
          titleLarge: TextStyle(fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontWeight: FontWeight.w800),
          bodyLarge: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AppColors {
  static const background = Color(0xFFFFFAF4);
  static const cream = Color(0xFFFFF1DE);
  static const green = Color(0xFF5E854D);
  static const greenSoft = Color(0xFFEFF7EA);
  static const orange = Color(0xFFEF8C55);
  static const orangeSoft = Color(0xFFFFEFE6);
  static const purple = Color(0xFF9B67AD);
  static const purpleSoft = Color(0xFFF5EAF8);
  static const yellow = Color(0xFFF3C850);
  static const yellowSoft = Color(0xFFFFF6DE);
  static const blue = Color(0xFF6DA6D7);
  static const blueSoft = Color(0xFFEAF4FF);
  static const ink = Color(0xFF251E17);
  static const muted = Color(0xFF81776C);
  static const line = Color(0xFFE8DED2);
}

enum EntryKind { expense, income }

class MoneyEntry {
  const MoneyEntry({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.kind,
  });

  final String title;
  final String category;
  final int amount;
  final DateTime date;
  final EntryKind kind;
}

class CategoryInfo {
  const CategoryInfo({
    required this.name,
    required this.icon,
    required this.color,
    required this.softColor,
    required this.budget,
  });

  final String name;
  final IconData icon;
  final Color color;
  final Color softColor;
  final int budget;
}

const categories = [
  CategoryInfo(
    name: 'Alimentación',
    icon: Icons.shopping_basket_outlined,
    color: AppColors.green,
    softColor: AppColors.greenSoft,
    budget: 120000,
  ),
  CategoryInfo(
    name: 'Hogar',
    icon: Icons.home_outlined,
    color: AppColors.orange,
    softColor: AppColors.orangeSoft,
    budget: 90000,
  ),
  CategoryInfo(
    name: 'Transporte',
    icon: Icons.directions_car_outlined,
    color: AppColors.purple,
    softColor: AppColors.purpleSoft,
    budget: 60000,
  ),
  CategoryInfo(
    name: 'Entretenimiento',
    icon: Icons.confirmation_number_outlined,
    color: AppColors.yellow,
    softColor: AppColors.yellowSoft,
    budget: 50000,
  ),
  CategoryInfo(
    name: 'Otros',
    icon: Icons.more_horiz,
    color: AppColors.blue,
    softColor: AppColors.blueSoft,
    budget: 40000,
  ),
];

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      return FinanceHome(onLogout: () => setState(() => _loggedIn = false));
    }
    return LoginScreen(onLogin: () => setState(() => _loggedIn = true));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
              children: [
                const SizedBox(height: 48),
                const Center(child: DogLogo(size: 190, showText: false)),
                const SizedBox(height: 20),
                Text(
                  'Mis gastitos',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.ink,
                    fontSize: 42,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Llevá el control de tus gastos\ncomo adulto independiente',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 20,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 44),
                const FieldLabel('Correo electrónico'),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: softInputDecoration(
                    hint: 'ejemplo@correo.com',
                    icon: Icons.mail_outline,
                  ),
                ),
                const SizedBox(height: 26),
                const FieldLabel('Contraseña'),
                const SizedBox(height: 10),
                TextField(
                  obscureText: !_showPassword,
                  autofillHints: const [AutofillHints.password],
                  decoration: softInputDecoration(
                    hint: 'Ingresa tu contraseña',
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      tooltip: _showPassword ? 'Ocultar' : 'Mostrar',
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 64,
                  child: FilledButton(
                    onPressed: widget.onLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const DividerWithText(text: 'o'),
                const SizedBox(height: 28),
                SizedBox(
                  height: 58,
                  child: OutlinedButton(
                    onPressed: widget.onLogin,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'G',
                          style: TextStyle(
                            color: Color(0xFF4285F4),
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 14),
                        Flexible(
                          child: Text(
                            'Iniciar sesión con Google',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      '¿No tenés cuenta? ',
                      style: TextStyle(color: AppColors.muted, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: widget.onLogin,
                      child: const Text('Registrate'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Icon(Icons.pets, color: Color(0xFFD9B894), size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FinanceHome extends StatefulWidget {
  const FinanceHome({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<FinanceHome> createState() => _FinanceHomeState();
}

class _FinanceHomeState extends State<FinanceHome> {
  int _pageIndex = 0;
  bool _hideBalance = false;
  final List<MoneyEntry> _entries = [
    MoneyEntry(
      title: 'Supermercado',
      category: 'Alimentación',
      amount: 25000,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      kind: EntryKind.expense,
    ),
    MoneyEntry(
      title: 'Luz',
      category: 'Hogar',
      amount: 40000,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      kind: EntryKind.expense,
    ),
    MoneyEntry(
      title: 'Pasaje',
      category: 'Transporte',
      amount: 5000,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      kind: EntryKind.expense,
    ),
    MoneyEntry(
      title: 'Freelance',
      category: 'Otros',
      amount: 320000,
      date: DateTime.now().subtract(const Duration(days: 3)),
      kind: EntryKind.income,
    ),
    MoneyEntry(
      title: 'Cine',
      category: 'Entretenimiento',
      amount: 25000,
      date: DateTime.now().subtract(const Duration(days: 4)),
      kind: EntryKind.expense,
    ),
  ];

  int get _income => _entries
      .where((entry) => entry.kind == EntryKind.income)
      .fold(0, (total, entry) => total + entry.amount);

  int get _spent => _entries
      .where((entry) => entry.kind == EntryKind.expense)
      .fold(0, (total, entry) => total + entry.amount);

  int get _balance => _income - _spent;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        balance: _balance,
        spent: _spent,
        entries: _entries,
        hideBalance: _hideBalance,
        onToggleBalance: () => setState(() => _hideBalance = !_hideBalance),
        onAddExpense: () => _openEntrySheet(EntryKind.expense),
        onAddIncome: () => _openEntrySheet(EntryKind.income),
        onGoReports: () => setState(() => _pageIndex = 2),
        onGoBudgets: () => setState(() => _pageIndex = 3),
      ),
      TransactionsPage(entries: _entries, onAdd: _openEntrySheet),
      ReportsPage(entries: _entries, spent: _spent, income: _income),
      BudgetsPage(entries: _entries),
      MorePage(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_pageIndex]),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar movimiento',
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => _openEntrySheet(EntryKind.expense),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 78,
        elevation: 10,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home,
              label: 'Inicio',
              selected: _pageIndex == 0,
              onTap: () => setState(() => _pageIndex = 0),
            ),
            NavItem(
              icon: Icons.receipt_long_outlined,
              label: 'Gastos',
              selected: _pageIndex == 1,
              onTap: () => setState(() => _pageIndex = 1),
            ),
            const SizedBox(width: 62),
            NavItem(
              icon: Icons.pie_chart_outline,
              label: 'Reportes',
              selected: _pageIndex == 2,
              onTap: () => setState(() => _pageIndex = 2),
            ),
            NavItem(
              icon: Icons.more_horiz,
              label: 'Más',
              selected: _pageIndex == 4,
              onTap: () => setState(() => _pageIndex = 4),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEntrySheet(EntryKind initialKind) async {
    final entry = await showModalBottomSheet<MoneyEntry>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => EntrySheet(initialKind: initialKind),
    );
    if (entry != null) {
      setState(() => _entries.insert(0, entry));
    }
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.balance,
    required this.spent,
    required this.entries,
    required this.hideBalance,
    required this.onToggleBalance,
    required this.onAddExpense,
    required this.onAddIncome,
    required this.onGoReports,
    required this.onGoBudgets,
  });

  final int balance;
  final int spent;
  final List<MoneyEntry> entries;
  final bool hideBalance;
  final VoidCallback onToggleBalance;
  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final VoidCallback onGoReports;
  final VoidCallback onGoBudgets;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      children: [
        const AppTopBar(),
        const SizedBox(height: 30),
        Text(
          'Hola Luz Valeria 👋',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.ink,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Llevá el control de tus gastitos ✨',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 22),
        BalanceCard(
          balance: balance,
          hideBalance: hideBalance,
          onToggle: onToggleBalance,
        ),
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Resumen de este mes',
          action: 'Ver más',
          onTap: onGoReports,
        ),
        const SizedBox(height: 14),
        SummaryCard(entries: entries, totalSpent: spent),
        const SizedBox(height: 22),
        QuickActions(
          onAddExpense: onAddExpense,
          onAddIncome: onAddIncome,
          onReports: onGoReports,
          onBudgets: onGoBudgets,
        ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Transacciones recientes',
          action: 'Ver todas',
        ),
        const SizedBox(height: 14),
        TransactionList(entries: entries.take(3).toList()),
      ],
    );
  }
}

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({
    super.key,
    required this.entries,
    required this.onAdd,
  });

  final List<MoneyEntry> entries;
  final Future<void> Function(EntryKind kind) onAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      children: [
        Text(
          'Gastos y entradas',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Registrá movimientos rápidos y revisá tu historial.',
          style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => onAdd(EntryKind.expense),
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text('Gasto'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onAdd(EntryKind.income),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Entrada'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        TransactionList(entries: entries),
      ],
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({
    super.key,
    required this.entries,
    required this.spent,
    required this.income,
  });

  final List<MoneyEntry> entries;
  final int spent;
  final int income;

  @override
  Widget build(BuildContext context) {
    final balance = income - spent;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      children: [
        Text('Reportes', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Entradas',
                value: formatGs(income),
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Gastos',
                value: formatGs(spent),
                color: AppColors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        MetricTile(
          label: 'Saldo del mes',
          value: formatGs(balance),
          color: balance >= 0 ? AppColors.green : AppColors.orange,
        ),
        const SizedBox(height: 24),
        SummaryCard(entries: entries, totalSpent: spent),
      ],
    );
  }
}

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key, required this.entries});

  final List<MoneyEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      children: [
        Text('Presupuestos', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text(
          'Controlá cuánto va quedando por categoría.',
          style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 22),
        ...categories.map((category) {
          final spent = spentByCategory(entries, category.name);
          final progress = category.budget == 0 ? 0.0 : spent / category.budget;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CategoryBadge(category: category),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${formatGs(spent)} / ${formatGs(category.budget)}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: progress.clamp(0, 1),
                      color: progress > 0.9 ? AppColors.orange : category.color,
                      backgroundColor: category.softColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      children: [
        const Center(child: DogLogo(size: 150, showText: true)),
        const SizedBox(height: 26),
        SoftCard(
          child: Column(
            children: [
              SettingsRow(icon: Icons.person_outline, title: 'Luz Valeria'),
              SettingsRow(
                icon: Icons.notifications_none,
                title: 'Recordatorios',
              ),
              SettingsRow(
                icon: Icons.currency_exchange,
                title: 'Guaraní paraguayo',
              ),
              SettingsRow(
                icon: Icons.logout,
                title: 'Cerrar sesión',
                onTap: onLogout,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.hideBalance,
    required this.onToggle,
  });

  final int balance;
  final bool hideBalance;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo actual',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        hideBalance ? 'Gs. ••••••' : formatGs(balance),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: hideBalance ? 'Mostrar saldo' : 'Ocultar saldo',
                      onPressed: onToggle,
                      icon: Icon(
                        hideBalance
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28, color: AppColors.line),
                const Text(
                  'Este mes',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.trending_up, color: AppColors.green, size: 22),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Gs. 40.000 vs. mes pasado',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const DogLogo(size: 132, showText: false),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.entries,
    required this.totalSpent,
  });

  final List<MoneyEntry> entries;
  final int totalSpent;

  @override
  Widget build(BuildContext context) {
    final spentItems = categories
        .map(
          (category) =>
              MapEntry(category, spentByCategory(entries, category.name)),
        )
        .where((item) => item.value > 0)
        .toList();

    return SoftCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final chart = SizedBox(
            width: compact ? 190 : 220,
            height: compact ? 190 : 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(220),
                  painter: DonutPainter(items: spentItems, total: totalSpent),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total gastado',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatGs(totalSpent),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
          final list = Column(
            children: categories.map((category) {
              final amount = spentByCategory(entries, category.name);
              final percent = totalSpent == 0 ? 0.0 : amount / totalSpent;
              return CategorySummaryRow(
                category: category,
                amount: amount,
                percent: percent,
              );
            }).toList(),
          );

          if (compact) {
            return Column(children: [chart, const SizedBox(height: 18), list]);
          }
          return Row(
            children: [
              chart,
              const SizedBox(width: 24),
              Expanded(child: list),
            ],
          );
        },
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onAddExpense,
    required this.onAddIncome,
    required this.onReports,
    required this.onBudgets,
  });

  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final VoidCallback onReports;
  final VoidCallback onBudgets;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
        QuickActionTile(
          label: 'Nuevo gasto',
          icon: Icons.add_circle_outline,
          color: AppColors.green,
          background: AppColors.greenSoft,
          onTap: onAddExpense,
        ),
        QuickActionTile(
          label: 'Nueva entrada',
          icon: Icons.receipt_long_outlined,
          color: AppColors.ink,
          background: AppColors.orangeSoft,
          onTap: onAddIncome,
        ),
        QuickActionTile(
          label: 'Reportes',
          icon: Icons.bar_chart,
          color: AppColors.purple,
          background: AppColors.purpleSoft,
          onTap: onReports,
        ),
        QuickActionTile(
          label: 'Presupuestos',
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.ink,
          background: AppColors.yellowSoft,
          onTap: onBudgets,
        ),
      ],
    );
  }
}

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.entries});

  final List<MoneyEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < entries.length; index++) ...[
            TransactionRow(entry: entries[index]),
            if (index < entries.length - 1)
              const Divider(height: 1, indent: 78, color: AppColors.line),
          ],
        ],
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  const TransactionRow({super.key, required this.entry});

  final MoneyEntry entry;

  @override
  Widget build(BuildContext context) {
    final category = categoryFor(entry.category);
    final isExpense = entry.kind == EntryKind.expense;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CategoryBadge(category: category),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  friendlyDate(entry.date),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isExpense ? '-' : '+'}${formatGs(entry.amount)}',
                style: TextStyle(
                  color: isExpense ? AppColors.ink : AppColors.green,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: category.softColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Text(
                    entry.category,
                    style: TextStyle(
                      color: category.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EntrySheet extends StatefulWidget {
  const EntrySheet({super.key, required this.initialKind});

  final EntryKind initialKind;

  @override
  State<EntrySheet> createState() => _EntrySheetState();
}

class _EntrySheetState extends State<EntrySheet> {
  late EntryKind _kind = widget.initialKind;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = categories.first.name;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nuevo movimiento',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          SegmentedButton<EntryKind>(
            segments: const [
              ButtonSegment(
                value: EntryKind.expense,
                label: Text('Gasto'),
                icon: Icon(Icons.remove_circle_outline),
              ),
              ButtonSegment(
                value: EntryKind.income,
                label: Text('Entrada'),
                icon: Icon(Icons.add_circle_outline),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (selection) =>
                setState(() => _kind = selection.first),
          ),
          const SizedBox(height: 18),
          const FieldLabel('Nombre'),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('entry-title-field'),
            controller: _titleController,
            textInputAction: TextInputAction.next,
            decoration: softInputDecoration(
              hint: _kind == EntryKind.expense ? 'Supermercado' : 'Sueldo',
              icon: Icons.edit_note,
            ),
          ),
          const SizedBox(height: 16),
          const FieldLabel('Monto'),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('entry-amount-field'),
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: softInputDecoration(
              hint: '25000',
              icon: Icons.payments,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: softInputDecoration(
              hint: 'Categoría',
              icon: Icons.category_outlined,
            ),
            items: categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category.name,
                    child: Text(category.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _category = value);
            },
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              key: const ValueKey('save-entry-button'),
              onPressed: _save,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final amount = int.tryParse(
      _amountController.text.replaceAll('.', '').replaceAll(',', ''),
    );
    if (amount == null || amount <= 0 || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completá nombre y monto para guardar.')),
      );
      return;
    }
    Navigator.of(context).pop(
      MoneyEntry(
        title: _titleController.text.trim(),
        category: _category,
        amount: amount,
        date: DateTime.now(),
        kind: _kind,
      ),
    );
  }
}

class DogLogo extends StatelessWidget {
  const DogLogo({super.key, required this.size, required this.showText});

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final dog = SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: DogPainter()),
    );
    if (!showText) return dog;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dog,
        const SizedBox(height: 8),
        Text(
          'Mis gastitos',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class DogPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 200;
    canvas.save();
    canvas.scale(scale);

    final fill = Paint()
      ..color = const Color(0xFFFFE7BD)
      ..style = PaintingStyle.fill;
    final ear = Paint()
      ..color = const Color(0xFFF5C98B)
      ..style = PaintingStyle.fill;
    final line = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final wallet = Paint()
      ..color = const Color(0xFF85562E)
      ..style = PaintingStyle.fill;
    final money = Paint()
      ..color = const Color(0xFF95B66D)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      const Rect.fromLTWH(34, 132, 132, 28),
      Paint()..color = const Color(0xFFEACFA9),
    );
    canvas.drawOval(const Rect.fromLTWH(28, 30, 102, 116), fill);
    canvas.drawOval(const Rect.fromLTWH(44, 50, 34, 68), ear);
    canvas.drawPath(
      Path()
        ..moveTo(52, 62)
        ..quadraticBezierTo(32, 84, 38, 108)
        ..quadraticBezierTo(47, 127, 70, 118)
        ..quadraticBezierTo(82, 89, 72, 62),
      line,
    );
    canvas.drawPath(
      Path()
        ..moveTo(86, 32)
        ..lineTo(104, 16)
        ..lineTo(100, 37)
        ..quadraticBezierTo(126, 28, 143, 44)
        ..quadraticBezierTo(122, 50, 132, 65)
        ..quadraticBezierTo(143, 75, 164, 75)
        ..quadraticBezierTo(181, 76, 185, 88)
        ..quadraticBezierTo(166, 86, 156, 102)
        ..quadraticBezierTo(139, 132, 106, 139)
        ..quadraticBezierTo(69, 149, 42, 126)
        ..quadraticBezierTo(24, 108, 30, 82)
        ..quadraticBezierTo(36, 54, 65, 44)
        ..quadraticBezierTo(54, 36, 86, 32),
      line,
    );
    canvas.drawCircle(const Offset(126, 78), 9, Paint()..color = AppColors.ink);
    canvas.drawCircle(
      const Offset(130, 74),
      3.2,
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      const Rect.fromLTWH(156, 83, 30, 18),
      Paint()..color = AppColors.ink,
    );
    canvas.drawPath(
      Path()
        ..moveTo(125, 103)
        ..quadraticBezierTo(142, 116, 161, 105),
      line..strokeWidth = 4,
    );

    canvas.drawPath(
      Path()
        ..moveTo(42, 132)
        ..quadraticBezierTo(8, 118, 27, 90)
        ..quadraticBezierTo(36, 115, 42, 132),
      line,
    );
    canvas.drawPath(
      Path()
        ..moveTo(84, 112)
        ..quadraticBezierTo(102, 139, 132, 130),
      line,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(106, 96, 58, 36),
        const Radius.circular(5),
      ),
      money,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(84, 112, 88, 52),
        const Radius.circular(10),
      ),
      wallet,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(84, 112, 88, 52),
        const Radius.circular(10),
      ),
      line,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(142, 126, 36, 28),
        const Radius.circular(7),
      ),
      wallet,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(142, 126, 36, 28),
        const Radius.circular(7),
      ),
      line,
    );
    canvas.drawCircle(
      const Offset(158, 140),
      8,
      Paint()..color = AppColors.yellow,
    );
    canvas.drawCircle(const Offset(158, 140), 8, line..strokeWidth = 3);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutPainter extends CustomPainter {
  DonutPainter({required this.items, required this.total});

  final List<MapEntry<CategoryInfo, int>> items;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.18;
    final rect =
        Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    if (total == 0) {
      paint.color = AppColors.line;
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, paint);
      return;
    }

    var start = -math.pi / 2;
    for (final item in items) {
      final sweep = (item.value / total) * math.pi * 2;
      paint.color = item.key.color;
      canvas.drawArc(rect, start, sweep - 0.04, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) =>
      oldDelegate.items != items || oldDelegate.total != total;
}

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Menú',
          onPressed: () {},
          icon: const Icon(Icons.menu, color: AppColors.ink, size: 34),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Notificaciones',
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.ink,
                size: 32,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? AppColors.green : AppColors.ink),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? AppColors.green : AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySummaryRow extends StatelessWidget {
  const CategorySummaryRow({
    super.key,
    required this.category,
    required this.amount,
    required this.percent,
  });

  final CategoryInfo category;
  final int amount;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CategoryBadge(category: category),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            formatGs(amount),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 38,
            child: Text(
              '${(percent * 100).round()}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: category.color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final CategoryInfo category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: category.softColor,
        shape: BoxShape.circle,
      ),
      child: Icon(category.icon, color: category.color),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Icon(icon, color: AppColors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (action != null)
          TextButton.icon(
            onPressed: onTap,
            label: Text(action!),
            icon: const Icon(Icons.chevron_right),
            iconAlignment: IconAlignment.end,
          ),
      ],
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 17,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.line)),
      ],
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

InputDecoration softInputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: AppColors.muted,
      fontWeight: FontWeight.w700,
    ),
    prefixIcon: Icon(icon, color: AppColors.green),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.line, width: 1.4),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.green, width: 1.8),
    ),
  );
}

CategoryInfo categoryFor(String name) {
  return categories.firstWhere(
    (category) => category.name == name,
    orElse: () => categories.last,
  );
}

int spentByCategory(List<MoneyEntry> entries, String category) {
  return entries
      .where(
        (entry) =>
            entry.kind == EntryKind.expense && entry.category == category,
      )
      .fold(0, (total, entry) => total + entry.amount);
}

String formatGs(int value) {
  final sign = value < 0 ? '-' : '';
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    final fromEnd = digits.length - index;
    buffer.write(digits[index]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return '${sign}Gs. $buffer';
}

String friendlyDate(DateTime date) {
  final now = DateTime.now();
  final time =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'Hoy, $time';
  }
  final yesterday = now.subtract(const Duration(days: 1));
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Ayer, $time';
  }
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}, $time';
}
