# 🚀 Render.com Deployment Guide for Flask Backend

## **📋 Prerequisites**

Before deploying, ensure you have:
1. ✅ A [Render.com](https://render.com) account (free tier available)
2. ✅ Your Supabase project URL and API key
3. ✅ Git repository pushed to GitHub/GitLab (Render connects to Git)

---

## **🔧 Step 1: Prepare Information**

You'll need the following information from your Supabase project:

### **From Supabase Dashboard:**
1. Go to [https://app.supabase.com](https://app.supabase.com)
2. Select your project
3. Go to **Settings** → **API**
4. Copy:
   - **Project URL** (e.g., `https://xleobapbuybenhoasomx.supabase.co`)
   - **Project API keys** → **anon/public** key (long JWT token)

### **Generate Security Keys:**
Run these commands to generate secure random keys:

```bash
# Generate SECRET_KEY
python3 -c "import secrets; print(secrets.token_urlsafe(32))"

# Generate JWT_SECRET_KEY
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

---

## **🌐 Step 2: Deploy to Render.com**

### **A. Create New Web Service**

1. Log in to [Render.com](https://dashboard.render.com/)
2. Click **"New +"** → **"Web Service"**
3. Connect your Git repository:
   - If first time: Click **"Connect GitHub/GitLab"** and authorize
   - Select your repository: `addiction-quit`

### **B. Configure Service**

Fill in the following settings:

| Setting | Value |
|---------|-------|
| **Name** | `addiction-quit-api` (or your choice) |
| **Region** | Choose closest to you |
| **Branch** | `main` (or your default branch) |
| **Root Directory** | `flask_server` |
| **Runtime** | `Python 3` |
| **Build Command** | `pip install -r requirements.txt` |
| **Start Command** | `gunicorn wsgi:app --bind 0.0.0.0:$PORT` |
| **Instance Type** | `Free` (or paid for better performance) |

### **C. Add Environment Variables**

Click **"Advanced"** → **"Add Environment Variable"** and add:

| Key | Value | Example |
|-----|-------|---------|
| `SUPABASE_URL` | Your Supabase project URL | `https://xleobapbuybenhoasomx.supabase.co` |
| `SUPABASE_KEY` | Your Supabase anon key | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `SECRET_KEY` | Generated secret (32+ chars) | `your-generated-secret-key` |
| `JWT_SECRET_KEY` | Generated JWT secret (32+ chars) | `your-generated-jwt-secret` |
| `FLASK_ENV` | `production` | `production` |
| `PORT` | `10000` | `10000` |
| `CORS_ORIGINS` | `*` (or your app domain) | `*` |

### **D. Create Web Service**

Click **"Create Web Service"** and wait for deployment (3-5 minutes)

---

## **✅ Step 3: Test Your Deployment**

Once deployed, Render will provide a URL like:
```
https://addiction-quit-api.onrender.com
```

Test the API:

```bash
# Health check
curl https://addiction-quit-api.onrender.com/health

# Root endpoint
curl https://addiction-quit-api.onrender.com/

# Expected response:
{
  "success": true,
  "message": "Addiction Quit API",
  "version": "1.0.0",
  ...
}
```

---

## **📱 Step 4: Update Flutter App**

After deployment, provide me with:

**✅ YOUR DEPLOYED URL:**
```
https://YOUR-SERVICE-NAME.onrender.com
```

I'll update the Flutter app configuration to point to your production API.

---

## **⚠️ Important Notes**

### **Free Tier Limitations:**
- ⏰ Services spin down after 15 minutes of inactivity
- 🐌 First request after sleep takes ~30-60 seconds (cold start)
- 💾 750 hours/month free (sufficient for testing)
- 🔄 Paid plans ($7/month) keep services always active

### **Security:**
- 🔐 Never commit `.env` file with production secrets
- 🔒 Use strong, random keys for `SECRET_KEY` and `JWT_SECRET_KEY`
- 🌐 Update `CORS_ORIGINS` to your app domain in production

### **Database:**
- 📊 Your Supabase PostgreSQL database is hosted separately (always active)
- 🔗 Flask connects to Supabase via environment variables

---

## **🐛 Troubleshooting**

### **Deployment Failed?**
- Check **Logs** tab in Render dashboard
- Verify all environment variables are set correctly
- Ensure `requirements.txt` is in `flask_server/` directory

### **API Not Responding?**
- Check service status in Render dashboard
- Verify Supabase credentials are correct
- Check if CORS is blocking requests

### **Cold Start Issues?**
- First request after 15min takes time (free tier)
- Upgrade to paid tier ($7/month) for always-on service
- Or use a cron job to ping the API every 10 minutes

---

## **🎉 Next Steps**

After successful deployment:

1. ✅ Copy your Render URL
2. ✅ Share it with me to update the Flutter app
3. ✅ Test authentication endpoints
4. ✅ Deploy your Flutter app (web/mobile)

**Need help?** Check Render logs or Supabase dashboard for errors.
