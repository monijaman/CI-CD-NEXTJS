# CI/CD Deployment Progress Summary

This document tracks the comprehensive steps completed for setting up Docker-based CI/CD deployment to AWS EC2 using GitHub Actions for the **monijaman/CI-CD-NEXTJS** repository.

## 🎯 Project OvYou'll get a scriptYou'll get a script like this:

```bash
# 1. Create folder
mkdir actions-runner && cd actions-runner

# 2. Download runner
curl -o actions-runner-linux-x64-2.315.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.315.0/actions-runner-linux-x64-2.315.0.tar.gz

# 3. Extract
tar xzf ./actions-runner-linux-x64-2.315.0.tar.gz

# 4. Configure
./config.sh --url https://github.com/your-org/your-repo --token ABCDEFG...

# 5. Run it
./run.shC2 user (ubuntu, etc.) is in the docker        run: |
          docker-compose down
          docker-compose build --no-cache
          docker-compose up -d --remove-orphans
```

That's it! 🎉 Your EC2 will now automatically deploy on every push to main, securely and locally.

## 🛡️ Runner Service Management

### Best Practice: Run as a System Serviceash
sudo usermod -aG docker ubuntu
```

You've cloned your repo:

```bash
git clone git@github.com:your-org/your-repo.git
```

### 3. Update Your Workflow
```yamlepository**: monijaman/CI-CD-NEXTJS
- **Current Branch**: GitHub_Actions
- **Application**: Next.js application with Docker containerization
- **Deployment Target**: AWS EC2 Ubuntu instance
- **CI/CD Platform**: GitHub Actions with self-hosted runner

## ✅ Completed Steps

### 1. **EC2 Instance Setup & Configuration**
   - ✅ Launched Ubuntu EC2 instance on AWS
   - ✅ Configured Security Groups:
     - Port 22 (SSH) - for remote access
     - Port 80 (HTTP) - for web traffic
     - Port 443 (HTTPS) - for secure web traffic
     - Port 3000 - for Next.js application
   - ✅ Obtained EC2 public IP/DNS for GitHub secrets

### 2. **Docker & Docker Compose Installation**
   - ✅ Updated Ubuntu packages: `sudo apt update`
   - ✅ Installed Docker: `sudo apt install -y docker.io`
   - ✅ Installed Docker Compose: `sudo apt install docker-compose`
   - ✅ Added EC2 user (`ubuntu`) to the `docker` group: `sudo usermod -aG docker ubuntu`
   - ✅ Enabled Docker to start on boot: `sudo systemctl enable docker`
   - ✅ Started Docker service: `sudo systemctl start docker`
   - ✅ Verified Docker installation: `docker --version`
   - ✅ Tested Docker without sudo: `docker ps`

### 3. **SSH Key Configuration & GitHub Authentication**
   - ✅ Generated SSH key pair locally (Windows): `ssh-keygen -t ed25519`
   - ✅ Located keys at: `C:\Users\USER\.ssh\id_ed25519` (private) and `id_ed25519.pub` (public)
   - ✅ EC2 Instance IP: `18.141.159.49`
   - ✅ EC2 Key Pair: `D:\pem\ec2-runner.pem`
   - ✅ Added public key to EC2's `~/.ssh/authorized_keys`
   - ✅ Uploaded private key to EC2: `scp -i "/d/pem/ec2-runner.pem" /c/Users/USER/.ssh/id_ed25519 ubuntu@18.141.159.49:~/.ssh/`
   - ✅ Set proper permissions on EC2: `chmod 600 ~/.ssh/id_ed25519`
   - ✅ Configured SSH agent: `eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519`
   - ✅ Added GitHub deploy key:
     - Repository → Settings → Deploy keys → Add deploy key
     - Title: "EC2 Runner"
     - Key: Public SSH key content (from `C:\Users\USER\.ssh\id_ed25519.pub`)
     - ✅ Enabled "Allow write access"
   - ✅ Tested GitHub SSH authentication: `ssh -T git@github.com`
   - ✅ Successfully authenticated as: "Hi monijaman! You've successfully authenticated..."
   - ✅ EC2 SSH Access: `ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.141.159.49`
   - ✅ Alternative SSH Access: `ssh -i "C:/Users/USER/.ssh/id_ed25519" ubuntu@18.141.159.49`

### 4. **GitHub Repository Preparation**
   - ✅ Created `Dockerfile` for Next.js application containerization
   - ✅ Created `docker-compose.yml` for service orchestration
   - ✅ Cloned repository to EC2: `git clone git@github.com:monijaman/CI-CD-NEXTJS.git`
   - ✅ Verified repository structure and files

### 5. **GitHub Actions Workflow Configuration**
   - ✅ Created `.github/workflows/deploy.yml` for automated deployment
   - ✅ Set up GitHub Repository Secrets:
     - `EC2_HOST`: EC2 public IP/DNS
     - `EC2_USER`: `ubuntu`
     - `EC2_SSH_KEY`: Private SSH key content
   - ✅ Configured workflow triggers on push to main branch
   - ✅ Implemented SSH-based deployment with Docker Compose

### 6. **Self-Hosted GitHub Actions Runner Setup**
   - ✅ Created GitHub Actions runner on EC2:
     - Repository → Settings → Actions → Runners → New self-hosted runner
     - OS: Linux, Architecture: x64
   - ✅ Downloaded and extracted runner:
     ```bash
     mkdir actions-runner && cd actions-runner
     curl -o actions-runner-linux-x64-2.315.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.315.0/actions-runner-linux-x64-2.315.0.tar.gz
     tar xzf ./actions-runner-linux-x64-2.315.0.tar.gz
     ```
   - ✅ Configured runner: `./config.sh --url https://github.com/monijaman/CI-CD-NEXTJS --token <TOKEN>`
   - ✅ Set up runner as system service for reliability:
     ```bash
     sudo ./svc.sh install
     sudo ./svc.sh start
     ```
   - ✅ Verified runner status: `sudo ./svc.sh status`

### 7. **Updated GitHub Actions Workflow for Self-Hosted Runner**
   - ✅ Modified workflow to use `runs-on: self-hosted`
   - ✅ Simplified deployment process:
     ```yaml
     - name: Docker Compose Up
       run: |
         docker-compose down
         docker-compose build --no-cache
         docker-compose up -d --remove-orphans
     ```

### 8. **Testing & Verification**
   - ✅ Verified Docker setup runs without sudo: `docker ps`
   - ✅ Tested SSH authentication to GitHub: `ssh -T git@github.com`
   - ✅ Successfully cloned repository: `git clone git@github.com:monijaman/CI-CD-NEXTJS.git`
   - ✅ Ran initial deployment test: `docker-compose up -d`
   - ✅ Verified self-hosted runner is online and responsive
   - ✅ Confirmed runner automatically starts on EC2 reboot

## 🔧 Current Status
- **EC2 Instance**: Fully configured and running at `18.141.159.49`
- **EC2 Key Pair**: `D:\pem\ec2-runner.pem`
- **SSH Key Type**: ED25519 (`C:\Users\USER\.ssh\id_ed25519`)
- **Docker**: Installed and properly configured for ubuntu user
- **SSH Authentication**: Working for both EC2 access and GitHub
- **Self-Hosted Runner**: Installed and running as system service
- **GitHub Actions**: Ready for automated deployments
- **Repository**: Successfully cloned and accessible on EC2

## 🚀 Next Steps
1. Test complete CI/CD pipeline with a code push
2. Monitor deployment logs and troubleshoot any issues
3. Implement proper environment variable management
4. Set up monitoring and logging for production
5. Configure SSL/TLS certificates for HTTPS
6. Implement backup and rollback strategies

---

## 📋 Prerequisites & Setup Guide

For Docker-based deployments to AWS EC2, this setup uses:

- **GitHub** for version control and CI
- **Docker** for containerization  
- **EC2** as the deployment server
- **GitHub Actions** for CI/CD automation
- **SSH + Docker Compose** for deployment

### Prerequisites Checklist
- ✅ EC2 Instance (Ubuntu preferred)
- ✅ Install: Docker + Docker Compose
- ✅ Open ports: 22 (SSH), 80/443 (web), 3000 (app)
- ✅ Add your GitHub SSH public key to `~/.ssh/authorized_keys`
- ✅ Your app is containerized with `Dockerfile` and `docker-compose.yml`
- ✅ GitHub Secrets configured:
  - `EC2_HOST`: your server's public IP or DNS
  - `EC2_USER`: usually `ubuntu`
  - `EC2_SSH_KEY`: your private key content

GitHub Secrets set:

EC2_HOST: your server’s public IP or DNS

EC2_USER: usually ubuntu

EC2_SSH_KEY: your private key (add as a GitHub secret, Base64 encoded or in plain text with proper escaping)

APP_NAME: optional if your deployment is in a subdir

## 🔧 Additional Implementation Details

### Project Structure
```
.
├── .github/
│   └── workflows/
│       └── deploy.yml
├── Dockerfile
├── docker-compose.yml
├── src/
└── ...
```

### Example GitHub Actions Workflow: .github/workflows/deploy.yml
```yaml
name: Deploy to EC2

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup SSH key
        run: |
          echo "${{ secrets.EC2_SSH_KEY }}" > key.pem
          chmod 600 key.pem

      - name: Deploy via SSH
        run: |
          ssh -o StrictHostKeyChecking=no -i key.pem ${{ secrets.EC2_USER }}@${{ secrets.EC2_HOST }} << 'EOF'
            cd /home/${{ secrets.EC2_USER }}/my-app
            git pull origin main
            docker-compose down
            docker-compose build --no-cache
            docker-compose up -d --remove-orphans
```

### EC2 Instance Setup Commands
```bash
# One-time setup
sudo apt update && sudo apt install -y docker.io docker-compose git
sudo usermod -aG docker ubuntu
exit
# Log in again

# Clone your repo
git clone git@github.com:your-user/your-repo.git my-app
cd my-app

# Run initially to test
docker-compose up -d
```

### docker-compose.yml Example
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
```

## 🤖 Self-Hosted Runner Setup Guide

### 1. Create Runner on GitHub
Go to your GitHub repo:

⚙️ Settings → Actions → Runners → New self-hosted runner

Choose:

OS: Linux

Architecture: x64

You’ll get a script like this:

bash
Copy
Edit
# 1. Create folder
mkdir actions-runner && cd actions-runner

# 2. Download runner
curl -o actions-runner-linux-x64-2.315.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.315.0/actions-runner-linux-x64-2.315.0.tar.gz

# 3. Extract
tar xzf ./actions-runner-linux-x64-2.315.0.tar.gz

# 4. Configure
./config.sh --url https://github.com/your-org/your-repo --token ABCDEFG...

# 5. Run it
./run.sh
```

To run as a service (recommended):

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

### 2. Configure Permissions
Make sure:

Your EC2 user (ubuntu, etc.) is in the docker group:

bash
Copy
Edit
sudo usermod -aG docker ubuntu
You’ve cloned your repo:

bash
Copy
Edit
git clone git@github.com:your-org/your-repo.git
3. Update Your Workflow (Inside GitHub)
yaml
Copy
Edit
# .github/workflows/deploy.yml

name: Deploy via EC2 Self-Hosted Runner

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: self-hosted

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Docker Compose Up
        run: |
          docker-compose down
          docker-compose build --no-cache
          docker-compose up -d --remove-orphans
That’s it. 🎉 Your EC2 will now automatically deploy on every push to main, securely and locally.



On your EC2 instance (e.g., Ubuntu) via SSH

 



🛡 Recommended: Run as a Service
Once it’s working, stop the script (Ctrl + C) and run:

 
sudo ./svc.sh install
sudo ./svc.sh start
This ensures the runner:

Starts automatically on EC2 reboot

Runs in the background like a system service





✅ Fix: Install Docker + Docker Compose
Run the following from your EC2 terminal:

1. Install Docker & Docker Compose
bash
Copy
Edit
# Install Docker
sudo apt update
sudo apt install -y docker.io

# Enable Docker to start on boot
sudo systemctl enable docker
sudo systemctl start docker

# Verify installation
docker --version
2. Add user to the Docker group
bash
Copy
Edit
# Create the docker group if it doesn't exist
sudo groupadd docker 2>/dev/null || true

# Add 'ubuntu' to the docker group
sudo usermod -aG docker ubuntu

# Log out and log back in for the group change to apply
exit
Then SSH back in again, and check:

 
docker ps
If it runs without sudo, Docker is now correctly set up for the ubuntu user.

3. (Optional) Install Docker Compose v2
 
sudo apt install docker-compose
docker-compose version



If you run the runner like this:
bash
Copy
Edit
./run.sh
It only runs in your current terminal session

If you Ctrl+C, log out, or reboot EC2 — it stops

✅ Best practice: Run it as a system service
Once you’ve configured the runner, run:

bash
Copy
Edit
cd ~/actions-runner
sudo ./svc.sh install
sudo ./svc.sh start
That way:

It runs in the background

Automatically starts on EC2 reboot

You don’t need to keep a terminal open

🔄 To check its status:
```bash
sudo ./svc.sh status
```

⏹ To stop the runner service:
```bash
sudo ./svc.sh stop
```

## 🔧 Troubleshooting Guide

### SSH Key Configuration

You need to add your SSH key to EC2 for GitHub authentication.

#### Option 1: Use GitHub deploy key or personal SSH key
🔑 Step-by-step:

On your local machine (not EC2), check your public SSH key:

```bash
cat ~/.ssh/id_ed25519.pub
# Or on Windows
type C:\Users\USER\.ssh\id_ed25519.pub
```

Copy the whole output (starts with ssh-ed25519).

On GitHub, go to:
- Repo → Settings → Deploy keys → Add deploy key
- Title: EC2 Runner
- Key: Paste the public key
- ✅ Check "Allow write access"

On EC2, place the matching private key:

If you already have the private key (id_ed25519) on your local system, upload it to EC2:

```bash
# Git Bash/WSL format
scp -i "/d/pem/ec2-runner.pem" /c/Users/USER/.ssh/id_ed25519 ubuntu@18.141.159.49:~/.ssh/

# PowerShell format
scp -i "D:\pem\ec2-runner.pem" "C:\Users\USER\.ssh\id_ed25519" ubuntu@18.141.159.49:~/
```

Then on EC2:

```bash
chmod 600 ~/.ssh/id_ed25519
```

And configure SSH:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Now test:

```bash
ssh -T git@github.com
```

It should return:

```bash
Hi monijaman! You've successfully authenticated...
```

Then retry:

```bash
git clone git@github.com:monijaman/CI-CD-NEXTJS.git
```

### Upload Private Key to EC2

📁 **Your specific setup:**
- Private key location: `C:\Users\USER\.ssh\id_ed25519`
- EC2 key pair: `D:\pem\ec2-runner.pem`
- EC2 instance IP: `18.141.159.49`

🆙 **Upload commands used:**
```bash
# Upload SSH private key to EC2 (Git Bash/WSL format)
scp -i "/d/pem/ec2-runner.pem" /c/Users/USER/.ssh/id_ed25519 ubuntu@18.141.159.49:~/.ssh/

# Alternative PowerShell format
scp -i "D:\pem\ec2-runner.pem" "C:\Users\USER\.ssh\id_ed25519" ubuntu@18.141.159.49:~/
```

🔗 **SSH connection methods:**
```bash
# Using EC2 key pair
ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.141.159.49

# Using uploaded SSH key (after setup)
ssh -i "C:/Users/USER/.ssh/id_ed25519" ubuntu@18.141.159.49

# Using uploaded SSH key (alternative format)
ssh -i ~/.ssh/id_ed25519 ubuntu@18.141.159.49
```

Then, on your EC2 (via SSH):

```bash
chmod 600 ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```