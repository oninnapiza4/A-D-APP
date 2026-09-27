// ═══════════════════════════════════════════════════════════════════════════
// Verify OTP Edge Function
// Checks if the submitted code is valid and not expired
// ═══════════════════════════════════════════════════════════════════════════

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { email, code } = await req.json();

    if (!email || !code) {
      return new Response(
        JSON.stringify({ error: "Email and code are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ── Initialize Supabase client ────────────────────────────────────────
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey);

    // ── Fetch OTP record ──────────────────────────────────────────────────
    const { data: verification, error: fetchError } = await supabase
      .from("email_verifications")
      .select("*")
      .eq("email", email)
      .eq("code", code)
      .single();

    if (fetchError || !verification) {
      return new Response(
        JSON.stringify({ 
          error: "Invalid verification code",
          valid: false 
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ── Check if already verified ─────────────────────────────────────────
    if (verification.verified) {
      return new Response(
        JSON.stringify({ 
          error: "Code already used",
          valid: false 
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ── Check expiry ──────────────────────────────────────────────────────
    const expiresAt = new Date(verification.expires_at);
    const now = new Date();

    if (now > expiresAt) {
      // Delete expired code
      await supabase
        .from("email_verifications")
        .delete()
        .eq("id", verification.id);

      return new Response(
        JSON.stringify({ 
          error: "Verification code has expired. Please request a new one.",
          valid: false,
          expired: true
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ── Mark as verified ──────────────────────────────────────────────────
    const { error: updateError } = await supabase
      .from("email_verifications")
      .update({ verified: true })
      .eq("id", verification.id);

    if (updateError) {
      console.error("Update error:", updateError);
      return new Response(
        JSON.stringify({ error: "Failed to verify code" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    console.log(`OTP verified for ${email}`);

    return new Response(
      JSON.stringify({ 
        success: true,
        valid: true,
        message: "Email verified successfully" 
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, "Content-Type": "application/json" } 
      }
    );

  } catch (error) {
    console.error("Error:", error);
    return new Response(
      JSON.stringify({ 
        error: error.message || "Failed to verify code",
        valid: false
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, "Content-Type": "application/json" } 
      }
    );
  }
});
