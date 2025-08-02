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

### ⚠️ **Troubleshooting: 502 Bad Gateway (nginx)**.

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

#### fatal: detected dubious ownership in repository at '/var/www/html/CI-CD-NEXTJS'

```bash
git config --global --add safe.directory /var/www/html/CI-CD-NEXTJS
```


#### fatal: Unable to create '/var/www/html/CI-CD-NEXTJS/.git/

This means Git doesn't have permission to write inside the .git directory — usually because the folder (or .git inside it) is owned by root or another user.

```bash
    sudo chown -R ubuntu:ubuntu /var/www/html/CI-CD-NEXTJS
```

optional: rm -f .git/index.lock


### when there is 404 issues
cp -r .next _next

 
## Add a new inbound rule to allow TCP port 3000:
Go to your AWS EC2 Console > Security Groups

- Select launch-wizard-4 (your current SG)

- Click on Inbound rules tab

- Click Edit inbound rules

- Click Add rule

Set:

Type: Custom TCP
Protocol: TCP
Port Range: 3000
Source: 0.0.0.0/0 (or restrict to your IP for security)

Save rules


##  1: Use the correct private RSA key

You must find the private key that matches the above ssh-rsa key.





# 🚀 Next.js SSR Deployment to AWS EC2 using GitHub Actions

This guide walks through how to deploy a Next.js SSR application from GitHub to an AWS EC2 instance using GitHub Actions and SSH keys.

---

## ✅ Requirements

- AWS EC2 Ubuntu instance (public IP + port 22 open in security group)
- Next.js project using `next start`
- GitHub repository with your code
- A working SSH key pair (we'll use ED25519)
- PM2 (used to run the Next.js server persistently)

---

## 🔐 Step 1: Generate and Install SSH Keys

### 🔸 On your local machine:

Generate a new ED25519 key pair:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "github-ec2-runner"
```

- This creates:
  - `~/.ssh/id_ed25519` (private key)
  - `~/.ssh/id_ed25519.pub` (public key)

---

### 🔸 On the EC2 instance:

1. SSH into EC2 using an existing key:
   ```bash
   ssh -i your-aws-key.pem ubuntu@<EC2-PUBLIC-IP>
   ```

2. Add the public key:
   ```bash
   nano ~/.ssh/authorized_keys
   ```

3. Paste the contents of `id_ed25519.pub` **at the end** of the file.

4. Save and exit.

---

### 🔸 On your local machine:

Test SSH with your new key:

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<EC2-PUBLIC-IP>
```

✅ If this works, you're ready to automate it.

---

## 🧪 Step 2: Prepare Your EC2 App Directory

1. SSH into the EC2 server:

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<EC2-PUBLIC-IP>
```

2. Clone your repo if not already cloned:

```bash
cd ~
git clone https://github.com/<your-username>/<your-repo>.git CI-CD-NEXTJS
```

3. Install PM2:

```bash
npm install -g pm2
```

---

## 🔐 Step 3: Add Private Key to GitHub

1. Open your private key:

```bash
cat ~/.ssh/id_ed25519
```

2. Copy the full contents.

3. In your GitHub repo:
   - Go to **Settings > Secrets > Actions**
   - Add a new secret:
     - Name: `EC2_SSH_KEY`
     - Value: *(paste full private key)*

---

## ⚙️ Step 4: Add GitHub Actions Workflow

In `.github/workflows/deploy.yml`:

```yaml
name: Deploy Next.js SSR to AWS

on:
  push:
    branches: [GitHub_Actions]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci --legacy-peer-deps

      - name: Run linting
        run: npm run lint

      - name: Build Next.js app
        run: npm run build

      - name: Zip deployment package
        run: zip -r deployment.zip . -x "node_modules/*" ".git/*" "*.md"

      - name: Upload to EC2
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.EC2_SSH_KEY }}
          source: "deployment.zip"
          target: "~/"

      - name: Deploy on EC2
        uses: appleboy/ssh-action@v0.1.7
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |
            cd ~/CI-CD-NEXTJS
            unzip -o ~/deployment.zip
            npm install --legacy-peer-deps
            pm2 delete nextjs-ci-cd || true
            pm2 start npm --name "nextjs-ci-cd" -- run start
            pm2 save
```

---

## 🔁 Bonus: Secrets to Add in GitHub

| Secret Name      | Description                     |
|------------------|---------------------------------|
| `EC2_HOST`       | Your EC2 public IP              |
| `EC2_SSH_KEY`    | Your **ED25519** private key    |

---

## ✅ Final Notes

- Make sure port **3000** is open in your EC2 security group **or** reverse proxy using NGINX on port 80.
- You can now deploy on every push to the `GitHub_Actions` branch!

---

Happy coding! 🎉



What to do?
1. Check disk space on your EC2 instance:
 
df -h
Look at % Used for / or other relevant partitions.

2. Free up space:
Remove unused Docker images, containers, volumes:

 
docker system prune -af
docker volume prune -f
Remove old log files, temp files:

 
sudo rm -rf /var/log/*.log
sudo rm -rf /tmp/*
Delete unnecessary files from your home directory or project folder..



### Docker compose:

# Update package list
sudo apt update

# Install prerequisites
sudo apt install -y ca-certificates curl gnupg

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker’s APT repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update again
sudo apt update

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Verify
docker --version
docker compose version
