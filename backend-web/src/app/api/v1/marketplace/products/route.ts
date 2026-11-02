import { NextResponse } from 'next/server';
import { query } from '@/lib/db';

export async function GET() {
  try {
    const rows = await query(
      `SELECT p.id, p.title, p.description, p.category, p.total_price,
              p.raw_material_cost, p.labor_wage_cost, p.packaging_transport_cost, p.fair_profit_margin,
              p.stock_quantity, u.full_name AS producer_name, u.reputation_score
       FROM products p
       JOIN users u ON p.producer_id = u.id
       WHERE p.is_active = TRUE
       ORDER BY p.created_at DESC`
    );

    return NextResponse.json({
      success: true,
      count: rows.length,
      data: rows,
    });
  } catch (error: any) {
    console.error('Error fetching products:', error);
    return NextResponse.json(
      { success: false, error: error.message || 'পণ্য লোড করতে ব্যর্থ হয়েছে' },
      { status: 500 }
    );
  }
}
