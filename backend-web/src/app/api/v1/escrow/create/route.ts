import { NextRequest, NextResponse } from 'next/server';
import { EscrowService } from '@/services/escrow.service';
import { z } from 'zod';

const CreateEscrowSchema = z.object({
  buyerId: z.string().min(1),
  productId: z.string().min(1),
  amount: z.number().positive(),
});

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const validatedData = CreateEscrowSchema.parse(body);

    const result = await EscrowService.lockBuyerFunds(validatedData);
    return NextResponse.json(result);
  } catch (error: any) {
    return NextResponse.json(
      { success: false, error: error.message || 'এসক্রো অর্ডার তৈরি ব্যর্থ হয়েছে' },
      { status: 400 }
    );
  }
}
