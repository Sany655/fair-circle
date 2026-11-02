import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FinancialHealthScreen extends StatefulWidget {
  const FinancialHealthScreen({super.key});

  @override
  State<FinancialHealthScreen> createState() => _FinancialHealthScreenState();
}

class _FinancialHealthScreenState extends State<FinancialHealthScreen> {
  double _salary = 45000;
  double _shieldPct = 40;
  double _usuryDebt = 25000;
  double _idleSavings = 850000;
  double _aidGiven = 10000;

  @override
  Widget build(BuildContext context) {
    final shieldedAmt = (_salary * (_shieldPct / 100)).round();
    final remainingFiat = (_salary - shieldedAmt).round();

    // Circulation Duty (~780,000 BDT Nisab threshold)
    double duty = 0;
    if (_idleSavings > 780000) {
      duty = (_idleSavings * 0.025);
    }
    final balanceRemaining = (duty - _aidGiven).clamp(0.0, double.infinity).round();

    // Score (Base 100)
    int score = 100;
    score -= ((_usuryDebt / 5000) * 5).clamp(0, 45).toInt();
    if (_shieldPct < 30) score -= (30 - _shieldPct).toInt();
    if (balanceRemaining > 0) score -= ((balanceRemaining / 5000) * 2).clamp(0, 20).toInt();
    if (_aidGiven > duty && duty > 0) score += 5;
    score = score.clamp(10, 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার আর্থিক স্বাস্থ্য', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Conscience Score Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: score >= 80 ? AppColors.primaryLight : const Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: score >= 80 ? AppColors.primary : AppColors.alertAmber,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: score >= 80 ? AppColors.primary : AppColors.alertAmber,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        score >= 80 ? 'আদর্শ নাগরিক (Uplifter)' : 'পরিবর্তনশীল সমর্থক',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'সুদমুক্ত সুরক্ষা এবং উদ্বৃত্ত সম্পদ সমাজের কল্যাণে আবর্তন হচ্ছে।',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Monthly Shielding Plan Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('মাসিক আয়ের সুরক্ষা পরিকল্পনা', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('৳$shieldedAmt', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const Divider(height: 16),
                _buildPlanRow('১. সুদের ঋণ ধ্বংস (Debt Defense):', '৳${(shieldedAmt * 0.30).round()}', AppColors.debtRed),
                _buildPlanRow('২. খাঁটি খাদ্য বাজার (Marketplace):', '৳${(shieldedAmt * 0.40).round()}', AppColors.primary),
                _buildPlanRow('৩. কৃষকে অগ্রিম বিনিয়োগ (Invest):', '৳${(shieldedAmt * 0.20).round()}', AppColors.investPurple),
                _buildPlanRow('৪. সুদমুক্ত ফান্ড জমা (Mutual Aid):', '৳${(shieldedAmt * 0.10).round()}', AppColors.alertAmber),
                const SizedBox(height: 6),
                Text('বাড়িভাড়া ও জরুরি বিল (অবশিষ্ট): ৳$remainingFiat', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Inputs Section
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('আয় ও ব্যয়ের স্লাইডার', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                _buildSlider(
                  label: 'মাসিক মোট আয় (Net Salary):',
                  valueDisplay: '৳${_salary.round()}',
                  value: _salary,
                  min: 15000,
                  max: 200000,
                  onChanged: (v) => setState(() => _salary = v),
                ),

                _buildSlider(
                  label: 'সুরক্ষিত করার শতাংশ:',
                  valueDisplay: '${_shieldPct.round()}%',
                  value: _shieldPct,
                  min: 10,
                  max: 90,
                  onChanged: (v) => setState(() => _shieldPct = v),
                ),

                _buildSlider(
                  label: 'সুদের ঋণ (Credit Card / Loan):',
                  valueDisplay: '৳${_usuryDebt.round()}',
                  value: _usuryDebt,
                  min: 0,
                  max: 150000,
                  onChanged: (v) => setState(() => _usuryDebt = v),
                ),

                _buildSlider(
                  label: 'অলস সঞ্চয় (Idle Savings):',
                  valueDisplay: '৳${_idleSavings.round()}',
                  value: _idleSavings,
                  min: 0,
                  max: 2000000,
                  onChanged: (v) => setState(() => _idleSavings = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanRow(String title, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textDark)),
          Text(val, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required String valueDisplay,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            Text(valueDisplay, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
