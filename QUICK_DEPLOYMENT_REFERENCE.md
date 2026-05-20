# 🚀 Quick Deployment Reference Card

## **📝 Information I Need From You**

After you deploy to Render.com, provide me with:

### **✅ Required:**
```
1. Your Render API URL: https://_________________.onrender.com
```

That's it! I'll handle the rest of the configuration.

---

## **🔑 Before You Deploy - Prepare These:**

### **1. Generate Security Keys:**
```bash
python3 -c "import secrets; print('SECRET_KEY=' + secrets.token_urlsafe(32))"
python3 -c "import secrets; print('JWT_SECRET_KEY=' + secrets.token_urlsafe(32))"
```

### **2. Get from Supabase Dashboard:**
- ✅ Project URL: `https://xleobapbuybenhoasomx.supabase.co`
- ✅ anon/public key: (already in `.env.example`)

---

## **🎯 Render.com Configuration**

### **Service Settings:**
```
Name:           addiction-quit-api
Root Directory: flask_server
Build Command:  pip install -r requirements.txt
Start Command:  gunicorn wsgi:app --bind 0.0.0.0:$PORT
```

### **Environment Variables:**
```
SUPABASE_URL      = YOUR_SUPABASE_PROJECT_URL
SUPABASE_KEY      = YOUR_SUPABASE_ANON_KEY
SECRET_KEY        = [your generated key from step 1]
JWT_SECRET_KEY    = [your generated key from step 1]
FLASK_ENV         = production
PORT              = 10000
CORS_ORIGINS      = *
```

---

## **✅ Test After Deployment:**

```bash
curl https://YOUR-SERVICE.onrender.com/health
```

Expected response:
```json
{
  "success": true,
  "message": "Server is running",
  "environment": "production"
}
```

---

## **📱 Flutter Commands (After I Update Config):**

### Development (local server):
```bash
flutter run --dart-define=ENV=development
```

### Production (Render server):
```bash
flutter run --dart-define=ENV=production --dart-define=API_BASE_URL=https://YOUR-SERVICE.onrender.com
```

### Build Release APK:
```bash
flutter build apk --release \
  --dart-define=ENV=production \
  --dart-define=API_BASE_URL=https://YOUR-SERVICE.onrender.com
```

---

## **⚡ Quick Tips:**

- 🆓 Free tier: Service sleeps after 15 minutes
- 🐌 First request after sleep: ~30-60 seconds
- 💰 Paid tier ($7/mo): Always-on, no cold starts
- 📊 Monitor: Render Dashboard → Logs tab
- 🔄 Redeploy: Push to Git, Render auto-deploys

---

**Ready?** Deploy on Render, then share your URL with me! 🎉
