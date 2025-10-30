# 🔧 Fix: Environment Variable Not Loading

## Problem
API requests are still going to `http://localhost:5001` instead of `http://192.168.1.108:5001` from `.env` file.

## ✅ Solution Steps

### Step 1: Verify .env File
```powershell
cd adminpanelui
Get-Content .env
```
Should show: `VITE_API_BASE_URL=http://192.168.1.108:5001`

### Step 2: Clear Vite Cache (IMPORTANT!)
```powershell
cd adminpanelui
Remove-Item -Recurse -Force node_modules/.vite -ErrorAction SilentlyContinue
```
Or run the provided script:
```powershell
.\restart-dev.ps1
```

### Step 3: Stop Dev Server Completely
- Press `Ctrl+C` in the terminal where dev server is running
- Wait for it to fully stop
- If it doesn't stop, close the terminal window

### Step 4: Restart Dev Server
```powershell
cd adminpanelui
npm run dev
```

### Step 5: Open Browser Console (F12)
Look for these logs when the page loads:

```
🔍 Environment Variable Check: {
  'VITE_API_BASE_URL raw': 'http://192.168.1.108:5001',
  ...
}
✅ Using .env value: http://192.168.1.108:5001
🔧 FINAL API Configuration: {
  'Base URL': 'http://192.168.1.108:5001',
  ...
}
🚀 Creating Axios instance with BASE_URL: http://192.168.1.108:5001
```

### Step 6: Test API Call
1. Try to login
2. Check Network tab (F12 → Network)
3. Request URL should be: `http://192.168.1.108:5001/api/auth/login`
4. NOT: `http://localhost:5001/api/auth/login`

## 🔍 Debugging

### If you see this in console:
```
❌ VITE_API_BASE_URL not found or empty!
```
**Solution:**
1. Check `.env` file exists in `adminpanelui/` directory
2. Verify variable name is exactly `VITE_API_BASE_URL` (case-sensitive)
3. No spaces: `VITE_API_BASE_URL=http://192.168.1.108:5001`
4. Restart dev server

### If you see this in console:
```
'All VITE_ keys': []
```
**This means Vite isn't reading .env file at all!**

**Solution:**
1. Make sure `.env` is in `adminpanelui/` directory (same level as `package.json`)
2. Check file encoding (should be UTF-8, no BOM)
3. Try recreating `.env` file:
   ```powershell
   Remove-Item .env
   Copy-Item env.example .env
   # Then edit .env and set: VITE_API_BASE_URL=http://192.168.1.108:5001
   ```
4. Restart dev server

### If still not working:
1. **Hard refresh browser**: `Ctrl+Shift+R` or `Cmd+Shift+R`
2. **Clear browser cache**: Chrome DevTools → Application → Clear Storage
3. **Check for multiple .env files**: 
   ```powershell
   Get-ChildItem -Filter ".env*" -Recurse
   ```
4. **Verify vite.config.ts** has `envPrefix: 'VITE_'` (it does)

## 📝 Quick Test

After restarting, open browser console and run:
```javascript
console.log('Test env:', import.meta.env.VITE_API_BASE_URL)
```
Should output: `http://192.168.1.108:5001`

## 🎯 Expected Behavior

After following all steps:
- ✅ Browser console shows correct URL from .env
- ✅ Network requests go to `http://192.168.1.108:5001`
- ✅ No more `localhost:5001` requests

## 🚨 Common Mistakes

1. **Editing .env while dev server is running** → Must restart!
2. **Not clearing Vite cache** → Old values cached
3. **Wrong variable name** → Must be `VITE_API_BASE_URL` exactly
4. **Spaces in .env** → `VITE_API_BASE_URL = value` is WRONG (no spaces around `=`)
5. **.env in wrong location** → Must be in `adminpanelui/` directory

---

**Status**: Ready to test! Follow steps above and check browser console.

