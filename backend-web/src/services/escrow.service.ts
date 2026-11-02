import pool from '@/lib/db';
import { v4 as uuidv4 } from 'uuid';

export interface LockEscrowParams {
  buyerId: string;
  productId: string;
  amount: number;
}

export class EscrowService {
  /**
   * Locks buyer funds into secure escrow inside an atomic PostgreSQL transaction
   */
  static async lockBuyerFunds(params: LockEscrowParams) {
    const { buyerId, productId, amount } = params;
    const client = await pool.connect();

    try {
      await client.query('BEGIN');

      // 1. Check buyer available balance
      const walletRes = await client.query(
        'SELECT id, available_balance FROM wallets WHERE user_id = $1 FOR UPDATE',
        [buyerId]
      );
      const buyerWallet = walletRes.rows[0];
      if (!buyerWallet || Number(buyerWallet.available_balance) < amount) {
        throw new Error('অপর্যাপ্ত ব্যালেন্স: আপনার ওয়ালেটে পর্যাপ্ত ব্যালেন্স নেই');
      }

      // 2. Fetch product details
      const prodRes = await client.query(
        'SELECT producer_id, title FROM products WHERE id = $1 AND is_active = TRUE',
        [productId]
      );
      const product = prodRes.rows[0];
      if (!product) throw new Error('পণ্যটি খুঁজে পাওয়া যায়নি বা সক্রিয় নয়');

      // 3. Move funds from available to locked_escrow
      await client.query(
        'UPDATE wallets SET available_balance = available_balance - $1, locked_escrow_balance = locked_escrow_balance + $1 WHERE id = $2',
        [amount, buyerWallet.id]
      );

      // 4. Create Escrow Order record (48-hour inspection guarantee)
      const escrowId = uuidv4();
      await client.query(
        `INSERT INTO escrow_orders (id, buyer_id, producer_id, product_id, order_amount, status)
         VALUES ($1, $2, $3, $4, $5, 'FUNDS_LOCKED')`,
        [escrowId, buyerId, product.producer_id, amount]
      );

      // 5. Append immutable ledger transaction (0.00 interest enforced)
      const ledgerId = uuidv4();
      await client.query(
        `INSERT INTO ledger_transactions (id, from_wallet_id, to_wallet_id, amount, interest_amount, transaction_type, reference_id, notes)
         VALUES ($1, $2, NULL, $3, 0.00, 'ESCROW_LOCK', $4, 'ক্রেতার তহবিল ৪৮ ঘণ্টার এসক্রো ভল্টে সংরক্ষিত')`,
        [ledgerId, buyerWallet.id, amount, escrowId]
      );

      await client.query('COMMIT');
      return { success: true, escrowId, message: 'তহবিল নিরাপদে এসক্রো ভল্টে লক করা হয়েছে' };
    } catch (error: any) {
      await client.query('ROLLBACK');
      throw new Error(error.message || 'এসক্রো লক ব্যর্থ হয়েছে');
    } finally {
      client.release();
    }
  }

  /**
   * Releases locked escrow to producer once buyer inspects and approves
   */
  static async releaseFunds(escrowId: string, buyerId: string) {
    const client = await pool.connect();

    try {
      await client.query('BEGIN');

      // 1. Fetch escrow order
      const escrowRes = await client.query(
        'SELECT * FROM escrow_orders WHERE id = $1 AND buyer_id = $2 FOR UPDATE',
        [escrowId, buyerId]
      );
      const escrow = escrowRes.rows[0];
      if (!escrow) throw new Error('এসক্রো অর্ডার পাওয়া যায়নি');
      if (escrow.status === 'SATISFIED_RELEASED') {
        throw new Error('এই অর্ডারটি ইতিমধ্যে নিষ্পত্তি করা হয়েছে');
      }

      // 2. Fetch producer wallet
      const sellerWalletRes = await client.query(
        'SELECT id FROM wallets WHERE user_id = $1 FOR UPDATE',
        [escrow.producer_id]
      );
      const sellerWallet = sellerWalletRes.rows[0];

      // 3. Fetch buyer wallet
      const buyerWalletRes = await client.query(
        'SELECT id FROM wallets WHERE user_id = $1 FOR UPDATE',
        [buyerId]
      );
      const buyerWallet = buyerWalletRes.rows[0];

      // 4. Transfer locked balance to producer available balance
      await client.query(
        'UPDATE wallets SET locked_escrow_balance = locked_escrow_balance - $1 WHERE id = $2',
        [escrow.order_amount, buyerWallet.id]
      );
      await client.query(
        'UPDATE wallets SET available_balance = available_balance + $1 WHERE id = $2',
        [escrow.order_amount, sellerWallet.id]
      );

      // 5. Update escrow status
      await client.query(
        "UPDATE escrow_orders SET status = 'SATISFIED_RELEASED', buyer_feedback_satisfaction = 1 WHERE id = $1",
        [escrowId]
      );

      // 6. Record release in ledger
      const ledgerId = uuidv4();
      await client.query(
        `INSERT INTO ledger_transactions (id, from_wallet_id, to_wallet_id, amount, interest_amount, transaction_type, reference_id, notes)
         VALUES ($1, $2, $3, $4, 0.00, 'ESCROW_RELEASE', $5, 'ক্রেতা সন্তুষ্ট; উৎপাদকের অ্যাকাউন্টে টাকা ছাড়')`,
        [ledgerId, buyerWallet.id, sellerWallet.id, escrow.order_amount, escrowId]
      );

      await client.query('COMMIT');
      return { success: true, message: 'উৎপাদকের কাছে অর্থ সফলভাবে পৌঁছে দেওয়া হয়েছে' };
    } catch (error: any) {
      await client.query('ROLLBACK');
      throw new Error(error.message || 'এসক্রো রিলিজ ব্যর্থ হয়েছে');
    } finally {
      client.release();
    }
  }
}
