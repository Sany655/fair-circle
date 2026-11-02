import { NextResponse } from 'next/server';

export interface BangladeshBankIndicators {
  policyRepoRate: number; // 9.50%
  standingLendingFacilityRate: number; // 11.00%
  weightedAverageLendingRate: number; // 11.83%
  consumerLoanBenchmarkRate: number; // 13.50% (Commercial banks average for personal & retail credit)
  sourceName: string;
  sourceUrl: string;
  policyRatesUrl: string;
  lastUpdated: string;
}

export async function GET() {
  const indicators: BangladeshBankIndicators = {
    policyRepoRate: 9.50,
    standingLendingFacilityRate: 11.00,
    weightedAverageLendingRate: 11.83,
    consumerLoanBenchmarkRate: 13.50,
    sourceName: 'বাংলাদেশ ব্যাংক (Bangladesh Bank)',
    sourceUrl: 'https://www.bb.org.bd/en/index.php/financialactivity/interestrate',
    policyRatesUrl: 'https://www.bb.org.bd/en/index.php/monetaryactivity/policyrates',
    lastUpdated: '২০২৬ হালনাগাদ (বাংলাদেশ ব্যাংক প্রকাশিত তফসিলি ব্যাংকসমূহের গড় সুদহার)',
  };

  return NextResponse.json({
    success: true,
    data: indicators,
  });
}
