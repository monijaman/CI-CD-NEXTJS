## 🖥️ **Quick Start: Serve a Static HTML File on EC2 Ubuntu**

Follow these steps to create and view a simple HTML file on your EC2 Ubuntu instance:

### **1. Connect to Your EC2 Instance**

Already done (you are at the shell prompt).

### **2. Create a Simple HTML File**

If you see both `index.html` and `index.nginx-debian.html` in `/var/www/html`, nginx will serve `index.html` by default.

- To update what is shown, simply overwrite `/var/www/html/index.html` as shown:

```bash
sudo sh -c 'echo "<!DOCTYPE html><html><head><title>EC2 Test</title></head><body><h1>Hello from EC2!</h1></body></html>" > /var/www/html/index.html'
sudo systemctl restart nginx
```

- You do **not** need to remove `index.nginx-debian.html`.  
- Browsing to `http://<your-ec2-public-ip>/` will show the contents of your new `index.html`.

### **3. Install a Simple Web Server (e.g., nginx or Python HTTP server)**

#### **Option A: Install and Use Python's built-in HTTP server**

```bash
# Install Python3 if not already installed
sudo apt update
sudo apt install python3 -y

# Serve files from your current directory
python3 -m http.server 8080
# Access at http://<your-ec2-public-ip>:8080/
```

#### **Option B: Install and Use nginx**

```bash
# Update package list and install nginx
sudo apt update
sudo apt install nginx -y

# Create the web root directory if it doesn't exist
sudo mkdir -p /var/www/html

# Create index.html directly in /var/www/html/
sudo sh -c 'echo "<!DOCTYPE html><html><head><title>EC2 Test</title></head><body><h1>Hello from EC2!</h1></body></html>" > /var/www/html/index.html'

# Restart nginx to serve the new file
sudo systemctl restart nginx

# Access at http://<your-ec2-public-ip>/
```

### **4. Open Your Browser**

- Go to: `http://18.141.203.114/` (replace with your EC2 public IP)
- You should see "Hello from EC2!"

### **5. Troubleshooting**

- If you can't access the page, check your EC2 security group rules:
  - Ensure inbound rules allow TCP port 80 (for nginx) or 8080 (for Python server) from your IP.

---

## 🚀 **Install and Run a Next.js App on EC2 Ubuntu**

Follow these steps to install and run a Next.js app on your EC2 instance:

### **1. Install Node.js and npm**

```bash
# Install Node.js (LTS) and npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### **2. Create a Next.js App**

```bash
# In your home directory or desired location
cd ~
npx create-next-app@latest my-nextjs-app
cd my-nextjs-app
```

### **3. Install Dependencies**

```bash
npm install
```

### **4. Build and Start the Next.js App**

```bash
# For development (default port 3000)
npm run dev

# For production
npm run build
npm start
```

### **5. Configure Security Group**

- Make sure your EC2 security group allows inbound traffic on TCP port 3000 (for Next.js dev server).

### **6. Access Your App**

- Open your browser and go to: `http://<your-ec2-public-ip>:3000/`

---

**Tip:**  
For production, consider using a process manager like PM2 and a reverse proxy (nginx) for better reliability.

---

## 🏗️ **Deploy Next.js with Nginx on EC2**

1. **Install Node.js and npm (if not already installed):**
   ```bash
   # Recommended way to install Node.js and npm together
   curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
   sudo apt-get install -y nodejs
   # Confirm npm is installed
   npm -v
   ```

2. **Clone your repo:**
   ```bash
   cd /var/www/html
   git clone https://github.com/monijaman/CI-CD-NEXTJS.git
   cd CI-CD-NEXTJS
   ```

3. **Install dependencies & build:**
   ```bash
   sudo npm install --legacy-peer-deps
   sudo npm run build
   ```

4. **Run Next.js with PM2 (recommended for production):**
   ```bash
   # Install PM2 globally
   sudo npm install -g pm2

   # Start your Next.js app with PM2
   pm2 start npm --name "nextjs-ci-cd" -- run start

   # Optional: Enable PM2 to restart on server reboot
   pm2 startup
   pm2 save

   # Check status
   pm2 status
   ```

5. **Configure Nginx as a reverse proxy:**
   - Edit `/etc/nginx/sites-available/default` and add:
     ```
     server {
         listen 80;
         server_name 18.141.203.114;

         location / {
             proxy_pass http://localhost:3000;
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection 'upgrade';
             proxy_set_header Host $host;
             proxy_cache_bypass $http_upgrade;
         }

         location /deploy.html {
             root /var/www/html;
         }
     }
     ```
   - Restart nginx:
     ```bash
     sudo systemctl restart nginx
     ```

6. **Access your app:**  
   - Visit: [http://18.141.203.114/](http://18.141.203.114/)

---

## 🔄 **Future: CI/CD**

- You can automate deployment using GitHub Actions or other CI/CD tools.
- Consider using PM2 to manage your Node.js process for reliability.
- For auto-deploy, set up a webhook or use SSH deploy scripts.

---

### ⚠️ **Troubleshooting: 502 Bad Gateway (nginx)**

If you see "502 Bad Gateway" from nginx, check:

- Is your Next.js app running?  
  If using PM2, run: `pm2 status` and `pm2 logs nextjs-app`
- Is it running on port 3000?  
  By default, Next.js uses port 3000. If you changed it, update the Nginx config.
- Is the firewall/security group allowing traffic on port 3000 (localhost)?  
  Nginx needs to reach your app on `localhost:3000`.
- Check logs:  
  - Nginx error log: `sudo tail -n 50 /var/log/nginx/error.log`
  - Next.js output: `pm2 logs nextjs-app`

Restart your Next.js app and Nginx after fixing issues:
```bash
pm2 restart nextjs-app
sudo systemctl restart nginx
```

> **Note:**  
> The `root /var/www/html;` directive assumes your static files (e.g., `deploy.html`) are located in `/var/www/html`.  
> If you move `deploy.html` to `/var/www/html/CI-CD-NEXTJS`, update the root to:
> ```
> root /var/www/html/CI-CD-NEXTJS;
> ```

---

### ⚠️ **Troubleshooting: 404 Not Found for _next/static/**

If you see errors like  
`GET http://18.141.203.114/_next/static/media/....woff2 404 (Not Found)`

Check the following:

- Make sure you ran `npm run build` before starting your app.
- Make sure you are running with `npm start` or PM2 (`pm2 start npm -- run start`), not `npm run dev`.
- The `.next` folder (created by build) must exist in your project directory.
- Your Nginx config should **not** have a `root` directive inside the `location /` block for Next.js.  
  Only use `proxy_pass` for Next.js routes.

Example (correct):
```
location / {
    proxy_pass http://localhost:3000;
    # ...other proxy settings...
}
```

If you set a `root` inside `location /`, remove it to avoid conflicts.

