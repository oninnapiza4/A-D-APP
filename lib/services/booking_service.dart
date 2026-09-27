import 'supabase_client.dart';

/// Data model returned by BookingService.
class BookingRecord {
  final String id;
  final String facility;
  final String package;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  const BookingRecord({
    required this.id,
    required this.facility,
    required this.package,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  factory BookingRecord.fromJson(Map<String, dynamic> j) {
    return BookingRecord(
      id: j['id'] as String,
      facility: j['facility'] as String,
      package: j['package'] as String,
      checkIn: DateTime.parse(j['check_in'] as String),
      checkOut: DateTime.parse(j['check_out'] as String),
      guests: j['guests'] as int,
      totalAmount: (j['total_amount'] as num).toDouble(),
      paymentMethod: j['payment_method'] as String,
      status: j['status'] as String,
      createdAt: DateTime.parse(j['created_at'] as String),
    );
  }
}

/// Result wrapper — same pattern as AuthResult.
class BookingResult {
  final bool success;
  final String? errorMessage;
  final BookingRecord? record;

  const BookingResult._({
    required this.success,
    this.errorMessage,
    this.record,
  });

  factory BookingResult.ok(BookingRecord record) =>
      BookingResult._(success: true, record: record);

  factory BookingResult.fail(String message) =>
      BookingResult._(success: false, errorMessage: message);
}

/// All Supabase database calls related to bookings.
///
/// Table expected in Supabase (run this SQL in the Supabase SQL Editor):
///
/// ```sql
/// create table if not exists public.bookings (
///   id             uuid primary key default gen_random_uuid(),
///   user_id        uuid references auth.users(id) on delete cascade,
///   facility       text not null,
///   package        text not null,
///   check_in       date not null,
///   check_out      date not null,
///   guests         int  not null default 1,
///   total_amount   numeric(10,2) not null,
///   payment_method text not null,
///   status         text not null default 'pending',
///   created_at     timestamptz default now()
/// );
///
/// -- Enable Row Level Security
/// alter table public.bookings enable row level security;
///
/// -- Users can only see their own bookings
/// create policy "Users view own bookings"
///   on public.bookings for select
///   using (auth.uid() = user_id);
///
/// -- Users can insert their own bookings
/// create policy "Users insert own bookings"
///   on public.bookings for insert
///   with check (auth.uid() = user_id);
/// ```
class BookingService {
  BookingService._();
  static final BookingService instance = BookingService._();

  // ── Create booking ───────────────────────────────────────────────────────

  Future<BookingResult> createBooking({
    required String facility,
    required String package,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    try {
      final userId = SupabaseClientService.currentUser?.id;
      if (userId == null) {
        return BookingResult.fail('You must be signed in to make a booking.');
      }

      final data = {
        'user_id': userId,
        'facility': facility,
        'package': package,
        'check_in': checkIn.toIso8601String().split('T').first,
        'check_out': checkOut.toIso8601String().split('T').first,
        'guests': guests,
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
        'status': 'pending',
      };

      final res = await SupabaseClientService.client
          .from('bookings')
          .insert(data)
          .select()
          .single();

      return BookingResult.ok(BookingRecord.fromJson(res));
    } catch (e) {
      return BookingResult.fail(
        'Failed to save booking: ${_cleanError(e)}',
      );
    }
  }

  // ── Fetch user's bookings ─────────────────────────────────────────────────

  Future<List<BookingRecord>> fetchMyBookings() async {
    try {
      final userId = SupabaseClientService.currentUser?.id;
      if (userId == null) return [];

      final res = await SupabaseClientService.client
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (res as List)
          .map((j) => BookingRecord.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Cancel booking ────────────────────────────────────────────────────────

  Future<bool> cancelBooking(String bookingId) async {
    try {
      await SupabaseClientService.client
          .from('bookings')
          .update({'status': 'cancelled'})
          .eq('id', bookingId);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _cleanError(Object e) {
    final msg = e.toString();
    // Strip "Exception:" prefix that Supabase sometimes adds
    if (msg.startsWith('Exception:')) {
      return msg.replaceFirst('Exception:', '').trim();
    }
    return msg;
  }
}
