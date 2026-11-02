import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

const CalculatorInputSchema = z.object({
  monthlySalary: z.number().min(0),
  shieldPercentage: z.number().min(10).max(90),
  usuryDebt: z.number().min(0),
  idleSavings: z.number().min(0),
  aidGiven: z.number().min(0),
});

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const data = CalculatorInputSchema.parse(body);

    const shieldedAmount = Math.round(data.monthlySalary * (data.shieldPercentage / 100));
    const remainingFiat = data.monthlySalary - shieldedAmount;

    // Proportional breakdown within shielded basket:
    const debtDefense = Math.round(shieldedAmount * 0.30);
    const realFood = Math.round(shieldedAmount * 0.40);
    const preOrderInvest = Math.round(shieldedAmount * 0.20);
    const mutualAidPool = Math.round(shieldedAmount * 0.10);

    // Circulation Duty (85g Gold Nisab Benchmark in BD ~ 7,80,000 BDT)
    const nisabThreshold = 780000;
    let circulationDuty = 0;
    if (data.idleSavings > nisabThreshold) {
      circulationDuty = Math.round(data.idleSavings * 0.025);
    }
    const balanceRemaining = Math.max(0, circulationDuty - data.aidGiven);

    // Conscience Score (Base 100)
    let score = 100;
    score -= Math.min(45, Math.round((data.usuryDebt / 5000) * 5));
    if (data.shieldPercentage < 30) score -= (30 - data.shieldPercentage);
    if (balanceRemaining > 0) score -= Math.min(20, Math.round((balanceRemaining / 5000) * 2));
    if (data.aidGiven > circulationDuty && circulationDuty > 0) score += 5;
    score = Math.max(10, Math.min(100, score));

    return NextResponse.json({
      success: true,
      conscienceScore: score,
      shieldedAmount,
      remainingFiat,
      allocations: {
        debtDefense,
        realFood,
        preOrderInvest,
        mutualAidPool,
      },
      circulation: {
        nisabThreshold,
        circulationDuty,
        aidGiven: data.aidGiven,
        balanceRemaining,
        status: data.idleSavings > nisabThreshold ? 'DUTY_APPLICABLE' : 'BELOW_THRESHOLD',
      },
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, error: error.message || 'ক্যালকুলেশন ব্যর্থ হয়েছে' },
      { status: 400 }
    );
  }
}
