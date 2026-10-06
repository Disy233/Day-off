DAYOFF — REAL LIVE BROADCAST BUILD
==================================

This package adds a REAL browser-to-browser live broadcast system using:
- WebRTC for live camera + microphone streaming
- Supabase Realtime for signaling (offer/answer/ICE)
- Supabase Postgres for live session discovery/status
- HTTPS camera/microphone permissions (GitHub Pages/Vercel are supported)

IMPORTANT: This is NOT a fake live button. When configured correctly, one Dayoff user can start a live broadcast and another Dayoff user can join and receive the real video/audio stream.

SETUP
-----
1. Open your Dayoff Supabase project.
2. Go to SQL Editor.
3. Run the COMPLETE supabase.sql in this folder.
   It contains the existing Dayoff tables plus the real live tables:
   - live_sessions
   - live_signals
   - live_comments
4. Open index.html and put your Supabase PUBLISHABLE key in:

   const KEY="PASTE_YOUR_SUPABASE_PUBLISHABLE_KEY_HERE";

   Do not use or publish a Supabase service_role/secret key in the browser.
5. Upload index.html to GitHub Pages or Vercel.
6. Use HTTPS. Camera/microphone access normally requires a secure context.

HOW TO TEST REAL LIVE
---------------------
You need TWO Dayoff accounts/devices or two browser sessions.

HOST DEVICE
1. Log in.
2. Tap Go Live.
3. Enter an optional title.
4. Tap Start Live.
5. Allow camera and microphone.
6. Your camera preview becomes the live host preview.
7. Keep the page open while broadcasting.

VIEWER DEVICE
1. Log in with a different Dayoff account.
2. Tap Go Live / Start Live to open the Live panel.
3. Refresh the live list.
4. The host's live broadcast should appear.
5. Tap Watch.
6. The viewer should receive the host's real video/audio through WebRTC.

ENDING A LIVE
-------------
The host taps End Live. The session changes from live to ended and connected viewers are notified that the connection ended.

NETWORK NOTE
------------
This build uses public STUN servers for WebRTC NAT traversal. It is real WebRTC, but some mobile/carrier/corporate networks may require a TURN relay. For a production-scale TikTok-style service, the next upgrade should be a dedicated TURN service and a scalable SFU/media server (for example LiveKit, Janus, mediasoup, or a managed WebRTC provider). That is different from a mock implementation: this package already performs real peer-to-peer streaming where the network permits it.

SCALING NOTE
------------
The current build is intentionally simple and Android-friendly. Each viewer receives a peer connection directly from the host, so the host's upload bandwidth increases as viewers increase. It is suitable for testing and small live rooms, not thousands of viewers.

TROUBLESHOOTING
---------------
If the Live panel says the live tables are missing:
- Run supabase.sql again.
- Make sure the SQL completes without errors.
- Make sure Realtime publication includes live_signals/live_sessions.

If camera access fails:
- Use the HTTPS GitHub Pages/Vercel URL.
- Allow camera and microphone permissions in Chrome.
- Make sure another application is not blocking the camera.

If a viewer sees the live listing but cannot connect:
- Test both devices on ordinary internet/Wi-Fi.
- Try a different network.
- A restrictive NAT/firewall may require TURN for reliable connection.

FILES
-----
index.html       Complete Dayoff frontend with real WebRTC Live
supabase.sql     Complete database setup, including live system
supabase_live.sql  Live-only SQL reference
.nojekyll        GitHub Pages helper
