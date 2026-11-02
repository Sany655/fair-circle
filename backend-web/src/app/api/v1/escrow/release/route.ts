import { NextRequest, NextResponse } from 'next/server';
import { EscrowService } from '@/services/escrow.service';
import { z } from 'zod';

const ReleaseEscrowSchema = z.object({
  escrowId: z.string().min(1),
  buyerId: z.string().min(1),
});

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const validatedData = ReleaseEscrowSchema.parse(body);

    const result = await EscrowService.releaseFunds(validatedData.escrowId, validatedData.buyerId);
    return NextResponse.json(result);
  } catch (error: any) {
    return NextResponse.json(
      { success: false, error: error.message || 'এসক্রো ফান্ড ছাড় করতে ব্যর্থ হয়েছে' },
      { status: 400 }
    );
  }
}
