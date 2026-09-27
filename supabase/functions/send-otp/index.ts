// ═══════════════════════════════════════════════════════════════════════════
// Send OTP Edge Function
// Generates a 6-digit code, stores it in DB, and emails it to the user
// ═══════════════════════════════════════════════════════════════════════════

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";
import { SMTPClient } from "https://deno.land/x/denomailer@1.6.0/mod.ts";

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
    const { email } = await req.json();

    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      return new Response(
        JSON.stringify({ error: "Valid email is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ── Initialize Supabase client ────────────────────────────────────────
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey);

    // ── Generate 6-digit OTP ──────────────────────────────────────────────
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    // ── Delete old codes for this email ──────────────────────────────────
    await supabase
      .from("email_verifications")
      .delete()
      .eq("email", email);

    // ── Insert new OTP record ─────────────────────────────────────────────
    const { error: insertError } = await supabase
      .from("email_verifications")
      .insert({
        email,
        code,
        expires_at: expiresAt.toISOString(),
        verified: false,
      });

    if (insertError) {
      console.error("Insert error:", insertError);
      return new Response(
        JSON.stringify({ error: "Failed to generate OTP" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // ── Send email via SMTP ───────────────────────────────────────────────
    const smtpHost = Deno.env.get("SMTP_HOST")!;
    const smtpPort = parseInt(Deno.env.get("SMTP_PORT") || "587");
    const smtpUser = Deno.env.get("SMTP_USER")!;
    const smtpPass = Deno.env.get("SMTP_PASS")!;
    const fromEmail = Deno.env.get("SMTP_FROM") || smtpUser;

    const client = new SMTPClient({
      connection: {
        hostname: smtpHost,
        port: smtpPort,
        tls: smtpPort === 465,
        auth: {
          username: smtpUser,
          password: smtpPass,
        },
      },
    });

    await client.send({
      from: fromEmail,
      to: email,
      subject: "A&D Thysia Resort – Email Verification Code",
      content: `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; background: #0a0f0d; }
    .container { max-width: 600px; margin: 40px auto; background: #0f1613; border-radius: 16px; overflow: hidden; box-shadow: 0 8px 32px rgba(0,0,0,0.3); }
    .header { background: linear-gradient(135deg, #1a3a2e 0%, #0f1613 100%); padding: 32px 24px; text-align: center; border-bottom: 2px solid #2d4a3e; }
    .logo { font-size: 24px; font-weight: 700; color: #d4af37; margin: 0; letter-spacing: 1px; }
    .subtitle { color: #8fa89e; font-size: 14px; margin: 8px 0 0 0; }
    .content { padding: 32px 24px; }
    .title { color: #e8f0ed; font-size: 20px; font-weight: 600; margin: 0 0 16px 0; }
    .text { color: #a8c0b5; font-size: 15px; line-height: 1.6; margin: 0 0 24px 0; }
    .code-box { background: #1a2821; border: 2px solid #2d4a3e; border-radius: 12px; padding: 24px; text-align: center; margin: 24px 0; }
    .code { font-size: 36px; font-weight: 700; color: #d4af37; letter-spacing: 8px; margin: 0; font-family: 'Courier New', monospace; }
    .code-label { color: #6b8578; font-size: 13px; margin: 8px 0 0 0; text-transform: uppercase; letter-spacing: 1px; }
    .warning { background: #2a1f1a; border-left: 4px solid #d4af37; padding: 12px 16px; border-radius: 8px; margin: 24px 0; }
    .warning-text { color: #d4af37; font-size: 13px; margin: 0; }
    .footer { background: #0a0f0d; padding: 24px; text-align: center; border-top: 1px solid #1a2821; }
    .footer-text { color: #6b8578; font-size: 12px; margin: 0 0 8px 0; }
    .link { color: #d4af37; text-decoration: none; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 class="logo">A&D THYSIA RESORT</h1>
      <p class="subtitle">Your Private Sanctuary Awaits</p>
    </div>
    <div class="content">
      <h2 class="title">Email Verification Required</h2>
      <p class="text">
        Welcome to A&D Thysia Resort! To complete your account registration, 
        please enter the verification code below in the app.
      </p>
      <div class="code-box">
        <div class="code">${code}</div>
        <p class="code-label">Verification Code</p>
      </div>
      <div class="warning">
        <p class="warning-text">
          ⏱️ This code expires in 10 minutes. Do not share it with anyone.
        </p>
      </div>
      <p class="text">
        If you didn't request this code, please ignore this email or contact 
        our support team if you have concerns.
      </p>
    </div>
    <div class="footer">
      <p class="footer-text">A&D Thysia Resort & Event's Place</p>
      <p class="footer-text">Barangay San Roque, Tiaong, Quezon</p>
      <p class="footer-text">
        <a href="https://www.facebook.com/adthysiaresortandeventsplace" class="link">Facebook</a> • 
        <a href="mailto:support@adthysia.com" class="link">Support</a>
      </p>
    </div>
  </div>
</body>
</html>
      `,
      html: true,
    });

    await client.close();

    console.log(`OTP sent to ${email}: ${code}`);

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: "Verification code sent to your email",
        expiresIn: 600 // seconds
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
        error: error.message || "Failed to send verification code" 
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, "Content-Type": "application/json" } 
      }
    );
  }
});
