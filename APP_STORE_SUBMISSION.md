# App Store Submission Guide — Safety Check (فحص السلامة)

This document is for the developer who will sign and upload the app to the App Store.

## 1. Build requirements
- macOS with **Xcode 16+** and **Flutter stable** (tested with 3.41.x, Dart SDK `^3.7.2`)
- An Apple Developer Program account (the app will be published under that account)

## 2. Secret file (NOT in the repository)
Create a file named `.env` in the project root (next to `pubspec.yaml`):

```
GROQ_API_KEY=<the key provided privately by the app owner>
GROQ_MODEL=qwen/qwen3.8-27b
```

> The build **fails** if `.env` is missing (it is declared as an asset).
> Without a valid key, every AI analysis returns "تعذر التحليل" → App Review rejection (2.1).
> Verify the key: `curl -H "Authorization: Bearer $KEY" https://api.groq.com/openai/v1/models` must return HTTP 200.

## 3. Signing & build
1. App Store Connect → create the app. Bundle ID currently set: `com.figmacrazy.bhapp` (change in Xcode if needed).
2. Open `ios/Runner.xcworkspace` → Runner target → Signing & Capabilities → select your Team (Automatic signing).
3. Build & upload:
   ```bash
   flutter clean
   flutter pub get
   flutter build ipa --release
   ```
   Then upload `build/ios/ipa/*.ipa` with **Transporter** or Xcode Organizer (Product → Archive → Distribute App).
4. Test on a real iPhone via TestFlight before submitting: take a photo → accept consent → result must appear.

## 4. Already handled in the code
| Item | Status |
|---|---|
| AI data-sharing consent dialog before sending photos (Guideline 5.1.1 / 5.1.2(i)) | ✅ `lib/services/ai_consent.dart` |
| In-app Privacy Policy screen + withdraw consent | ✅ Settings |
| Photos resized to ≤1600px / JPEG 80% (Groq 4 MB base64 limit) | ✅ `camera_screen.dart` |
| Camera / Photos usage descriptions | ✅ `Info.plist` |
| `ITSAppUsesNonExemptEncryption = false` (no export compliance questions) | ✅ |
| Portrait only, `UIRequiresFullScreen` (iPad validation) | ✅ |
| Minimum iOS 13.0 | ✅ |
| No dead buttons ("About" now opens a dialog) | ✅ |

## 5. App Store Connect metadata

**Privacy Policy URL** (required): host `docs/privacy-policy.html` — e.g. enable GitHub Pages (Settings → Pages → branch `main`, folder `/docs`) →
`https://<user>.github.io/<repo>/privacy-policy.html`. Replace `SUPPORT_EMAIL_HERE` with a real email first.

**App Privacy (nutrition label):**
- Data collected: **Photos or Videos** → Used for *App Functionality* → **Not linked** to the user → **Not used for tracking**.
- Everything else: Not collected.

**Category:** Utilities (or Productivity) · **Age rating:** 4+

**Suggested name:** `فحص السلامة - Safety Check AI` (the plain name "Safety Check" may already be taken)

**Description (AR):**
فحص السلامة يساعدك على اكتشاف مخاطر السلامة في أي مكان بصورة واحدة. التقط صورة أو اخترها من المعرض، وسيحللها الذكاء الاصطناعي ليكشف المخاطر مثل الأسلاك المكشوفة، الأرضيات المبللة، مخارج الطوارئ المحجوبة، وعوائق الممرات، مع تحديد مكان كل خطر ومستوى الخطورة وتوصيات عملية، وإمكانية تصدير تقرير PDF.
تنبيه: النتائج إرشادية ولا تغني عن فحص مختص.

**Description (EN):**
Safety Check helps you spot safety hazards with a single photo. Take or choose a picture and AI highlights risks such as exposed wires, wet floors, blocked emergency exits and obstructed walkways, showing where each hazard is, its severity and practical recommendations. Export a PDF report.
Note: results are for guidance only and do not replace a professional inspection.

**Keywords:** safety,inspection,hazard,risk,AI,سلامة,فحص,مخاطر,أمان,تقرير

**Notes for App Review:**
> No login required. Tap "Start Scan" → choose a photo (or take one) → accept the data-sharing consent dialog → the AI result appears within a few seconds. Photos are sent only after explicit consent to Groq, Inc. for analysis and are not stored.

**Screenshots required:** 6.9" iPhone (1320×2868) and, since iPad is supported, 13" iPad (2064×2752).
If you don't want to provide iPad screenshots, set `TARGETED_DEVICE_FAMILY = 1` (iPhone only) in Xcode before archiving.

## 6. Security note
The Groq key is bundled inside the app and can be extracted. Set a spending limit in the Groq console, and consider moving the call behind a small proxy (e.g. Cloudflare Worker) in a future version.
