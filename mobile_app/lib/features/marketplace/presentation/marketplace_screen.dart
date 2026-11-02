import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FairCircle মার্কেটপ্লেস',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '১০০% খাঁটি পণ্য • উৎপাদক সমবায় হাট',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Text('০% সুদ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Escrow Guarantee Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '৪৮ ঘণ্টার এসক্রো গ্যারান্টি: পণ্য হাতে পেয়ে পরীক্ষার পরই উৎপাদকের কাছে টাকা ছাড় হয়।',
                    style: TextStyle(fontSize: 11, color: AppColors.textDark, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Product 1
          _buildProductCard(
            context: context,
            title: 'কাঠের ঘানির খাঁটি সরিষার তেল (৫ লিটার)',
            producer: 'পাবনা কৃষক সমবায় #১২',
            price: '৳২,৪০০',
            rawCost: '৳১,৮৫০',
            laborCost: '৳১৮০',
            fairProfit: '৳৩৭০',
            syndicateCut: '৳৬৫০',
          ),
          const SizedBox(height: 12),

          // Product 2
          _buildProductCard(
            context: context,
            title: 'হাতে কাটা দেশি খাদি সুতির পাঞ্জাবী',
            producer: 'টাঙ্গাইল তাঁত সমবায় #০৪',
            price: '৳১,৫০০',
            rawCost: '৳৬৫০',
            laborCost: '৳৭০০',
            fairProfit: '৳১৫০',
            syndicateCut: '৳২,০০০',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required String title,
    required String producer,
    required String price,
    required String rawCost,
    required String laborCost,
    required String fairProfit,
    required String syndicateCut,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(producer, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
              const Text('যাচাইকৃত উৎপাদক', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 10),

          // Transparent Price Breakdown
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _buildBreakdownRow('কাঁচামাল ও ভাঙানো:', rawCost),
                _buildBreakdownRow('মজুরি ও পরিবহন:', laborCost),
                _buildBreakdownRow('কৃষক/তাঁতীর ন্যায্য লাভ:', fairProfit, isProfit: true),
                const Divider(height: 12, color: AppColors.border),
                _buildBreakdownRow('মধ্যস্বত্বভোগী সিন্ডিকেট:', '$syndicateCut (এখানে ৳০)', isStrike: true),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                  const Text('সর্বমোট মূল্য', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showEscrowSheet(context, title, price, producer);
                },
                icon: const Icon(Icons.arrow_forward, size: 14),
                label: const Text('সরাসরি অর্ডার', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildBreakdownRow(String label, String value, {bool isProfit = false, bool isStrike = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isProfit ? FontWeight.bold : FontWeight.w500,
              color: isProfit ? AppColors.primary : (isStrike ? AppColors.debtRed : AppColors.textDark),
              decoration: isStrike ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  static void _showEscrowSheet(BuildContext context, String title, String price, String producer) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🛡️ ৪৮ ঘণ্টার সুরক্ষিত এসক্রো অর্ডার', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('$title ($price)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const SizedBox(height: 12),
            const Text('১. আপনার টাকা সরাসরি বিক্রেতা পাবে না; এসক্রো ভল্টে নিরাপদে থাকবে।', style: TextStyle(fontSize: 11)),
            const SizedBox(height: 6),
            const Text('২. পণ্য হাতে পাওয়ার পর আপনি ৪৮ ঘণ্টা পরখ করার সময় পাবেন।', style: TextStyle(fontSize: 11)),
            const SizedBox(height: 6),
            const Text('৩. আপনি সন্তুষ্ট হলেই কেবল টাকা উৎপাদকের অ্যাকাউন্টে যাবে।', style: TextStyle(fontSize: 11)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('আলহামদুলিল্লাহ! এসক্রো অর্ডার নিশ্চিত হয়েছে।')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                child: const Text('অর্ডার নিশ্চিত করুন'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
