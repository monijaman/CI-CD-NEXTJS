# CI/CD Deployment Documentation
## Next.js Application on AWS EC2 with GitHub Actions

---

## 📊 **Project Overview**

| **Attribute** | **Details** |
|---------------|-------------|
| **Repository** | `monijaman/CI-CD-NEXTJS` |
| **Branch** | `GitHub_Actions` |
| **Application** | Next.js with Docker containerization |
| **Deployment Target** | AWS EC2 Ubuntu instance |
| **CI/CD Platform** | GitHub Actions with self-hosted runner |
| **EC2 Instance** | `18.136.198.116` (Updated) |
| **SSH Key Type** | ED25519 |

---

## ✅ **Deployment Progress Summary**

### **Phase 1: Infrastructure Setup**
- [x] **EC2 Instance Configuration**
  - Ubuntu EC2 instance launched on AWS
  - Security groups configured (ports 22, 80, 443, 3000)
  - Instance IP: `18.136.198.116` (Updated)
  - EC2 key pair: `D:\pem\ec2-runner.pem`

### **Phase 2: Environment Setup**
- [x] **Docker Installation**
  - Docker Engine installed and configured
  - Docker Compose installed
  - User added to docker group for sudo-less access
  - Service enabled for auto-start on boot

### **Phase 3: Security & Authentication**
- [x] **SSH Key Management**
  - ED25519 key pair generated: `C:\Users\USER\.ssh\id_ed25519`
  - Private key uploaded to EC2: `~/.ssh/id_ed25519`
  - Proper permissions set (600)
  - SSH agent configured
- [x] **GitHub Integration**
  - Deploy key added to repository with write access
  - SSH authentication verified with GitHub
  - Repository successfully cloned on EC2

### **Phase 4: CI/CD Pipeline**
- [x] **GitHub Actions Setup**
  - Workflow file created: `.github/workflows/deploy.yml`
  - Repository secrets configured
  - Self-hosted runner installed and configured
  - Runner set up as system service for reliability

### **Phase 5: Testing & Verification**
- [x] **System Validation**
  - Docker functionality verified (sudo-less operation)
  - GitHub SSH authentication confirmed
  - Repository access validated
  - Initial deployment test successful
  - Runner auto-start on reboot confirmed

---

## 🎯 **Current Status**

| **Component** | **Status** | **Details** |
|---------------|------------|-------------|
| **EC2 Instance** | ✅ **Running** | `18.136.198.116` - New IP address |
| **Security Groups** | ✅ **Configured** | SSH port 22 open from 0.0.0.0/0 |
| **Repository Secrets** | ❌ **OUTDATED** | EC2_HOST still points to old IP |
| **GitHub Actions** | ❌ **FAILING** | drone-scp timeout - old IP in secrets |
| **Self-Hosted Runner** | ❓ **Unknown** | Cannot verify due to IP mismatch |
| **Local Connection** | ⚠️ **TEST NEEDED** | Need to test new IP connectivity |

**🚨 CRITICAL ISSUE:** GitHub Actions using old IP (18.141.159.49) - Update EC2_HOST secret to 18.136.198.116

---

## 🚀 **Quick Start Commands**

### **Connect to EC2**
```bash
# Using EC2 key pair
ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.136.198.116

# Using SSH key (after setup)
ssh -i "C:/Users/USER/.ssh/id_ed25519" ubuntu@18.136.198.116
```

### **Check System Status**
```bash
# Docker status
docker --version
docker ps

# Runner status
sudo ./svc.sh status

# GitHub authentication
ssh -T git@github.com
```

---

## 🛠️ **Technical Architecture**

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Developer     │    │    GitHub        │    │   AWS EC2       │
│   Local Code    │───▶│    Actions       │───▶│   Application   │
│                 │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Git Push      │    │ Self-Hosted      │    │ Docker Compose  │
│   to main       │    │ Runner           │    │ Deployment      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

---

## 📋 **Prerequisites Checklist**

### **AWS Infrastructure**
- [x] EC2 instance (Ubuntu 20.04 LTS)
- [x] Security group configuration
- [x] Elastic IP or stable public IP
- [x] EC2 key pair for access

### **Local Development**
- [x] SSH key pair generated
- [x] Git configured
- [x] Access to repository
- [x] Docker files created

### **GitHub Configuration**
- [x] Repository with Docker files
- [x] Deploy key with write access
- [x] Repository secrets configured
- [x] Workflow file created

---

## ⚙️ **Configuration Details**

### **GitHub Repository Secrets**
```
EC2_HOST = 18.136.198.116
EC2_USER = ubuntu
EC2_SSH_KEY = [Private SSH key content]
```

### **SSH Key Locations**
```
Local Private Key: C:\Users\USER\.ssh\id_ed25519
Local Public Key:  C:\Users\USER\.ssh\id_ed25519.pub
EC2 Private Key:   ~/.ssh/id_ed25519
EC2 Key Pair:      D:\pem\ec2-runner.pem
```

### **Project Structure**
```
CI-CD-NEXTJS/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── src/
│   └── app/
├── Dockerfile
├── docker-compose.yml
├── package.json
└── next.config.ts
```

---

## 🔄 **Deployment Workflow**

### **Automated Process**
1. **Code Push** → Developer pushes to `main` branch
2. **Trigger** → GitHub Actions workflow activates
3. **Runner** → Self-hosted runner on EC2 executes
4. **Build** → Docker image built from source
5. **Deploy** → Container deployed with zero downtime
6. **Verify** → Health checks confirm successful deployment

### **Manual Deployment**
```bash
# Connect to EC2
ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.136.198.116

# Navigate to project
cd /home/ubuntu/CI-CD-NEXTJS

# Deploy manually
docker-compose down
docker-compose build --no-cache
docker-compose up -d --remove-orphans
```

---

## 🔧 **Troubleshooting Guide**

### **Common Issues & Solutions**

| **Issue** | **Solution** |
|-----------|--------------|
| SSH connection fails | Verify key permissions: `chmod 600 ~/.ssh/id_ed25519` |
| Docker permission denied | Add user to docker group: `sudo usermod -aG docker ubuntu` |
| GitHub authentication fails | Check deploy key and SSH agent: `ssh-add ~/.ssh/id_ed25519` |
| Runner offline | Restart service: `sudo ./svc.sh restart` |
| Port conflicts | Check port usage: `sudo netstat -tlnp \| grep :3000` |
| **SCP/Drone timeout** | **Network connectivity issue - see below** |

### **Deployment Connectivity Issues**

#### **Confirmed Issue: SSH Connection Timeout**
```
debug1: Connecting to 18.136.198.116 [18.136.198.116] port 22.
debug1: connect to address 18.136.198.116 port 22: Connection timed out
ssh: connect to host 18.136.198.116 port 22: Connection timed out
```

#### **Drone-SCP Timeout Error (CURRENT ISSUE)**
```
drone-scp version: v1.6.14
tar all files into /tmp/JKlZmNsCFQ.tar.gz
remote server os type is unix
scp file to server.
2025/07/28 06:37:41 error copy file to dest: ***, error message: dial tcp ***:22: i/o timeout
drone-scp error: error copy file to dest: ***, error message: dial tcp ***:22: i/o timeout
```

**🚨 ROOT CAUSE:** GitHub Actions repository secrets still contain old IP address

**🎯 IMMEDIATE FIX REQUIRED:** Update GitHub Repository Secrets

**🚨 IMMEDIATE ACTION REQUIRED:**

**🎯 CRITICAL FIX:** GitHub Repository Secrets Update

**Step 1: Update Repository Secrets**
1. Go to: `https://github.com/monijaman/CI-CD-NEXTJS/settings/secrets/actions`
2. Update the following secret:
   ```
   EC2_HOST = 18.136.198.116  (OLD: 18.141.159.49)
   ```
3. Verify other secrets are correct:
   ```
   EC2_USER = ubuntu
   EC2_SSH_KEY = [Your private SSH key content]
   ```

**Step 2: Test Connection After Update**
```bash
# After updating secrets, trigger a new deployment
git add .
git commit -m "Update IP address in documentation"
git push origin main
```

**Root Causes & Solutions:**

1. **✅ EC2 Security Group Analysis (RESOLVED)**
2. **✅ EC2 Instance Status (CONFIRMED RUNNING)**

**🔍 NEXT INVESTIGATION STEPS:**

3. **🚨 Network Connectivity Test (CRITICAL FINDING)**
   ```bash
   # CONFIRMED: Complete network isolation
   ping 18.136.198.116                    # 100% packet loss
   ping ec2-18-136-198-116.ap-southeast-1.compute.amazonaws.com  # 100% packet loss
   
   # DNS resolution works: hostname → 18.136.198.116 ✅
   # Network routing fails: cannot reach IP ❌
   ```
   
   **🚨 ROOT CAUSE IDENTIFIED:** IP Address Changed - Update all configurations!

4. **⚠️ Network ACLs Check (HIGH PRIORITY)**
   ```bash
   # Check Network ACLs in AWS Console:
   # VPC → Network ACLs → Find your subnet's ACL
   # Verify: Inbound rule allows TCP 22 from 0.0.0.0/0
   # Verify: Outbound rule allows responses
   ```

4. **⚠️ Instance-Level Firewall (Ubuntu UFW)**
   ```bash
   # If you can access via AWS Session Manager:
   sudo ufw status
   sudo ufw allow 22/tcp
   sudo ufw reload
   
   # Check iptables
   sudo iptables -L -n
   ```

5. **⚠️ AWS Regional/Network Issues**
   ```bash
   # Test from different network/location
   # Check AWS Service Health Dashboard
   # Try connecting from AWS CloudShell
   ```
   
   **Current Inbound Rules (from AWS Console):**
   ```
   Security Group: sg-0136364490ee99311 (default)
   
   Rule 1: HTTPS  | TCP | Port 443 | Source: 0.0.0.0/0
   Rule 2: SSH    | TCP | Port 22  | Source: 0.0.0.0/0 ✅
   Rule 3: HTTP   | TCP | Port 80  | Source: 0.0.0.0/0
   Rule 4: All traffic | All | All | Source: sg-0136364490ee99311 (self-reference)
   ```
   
   **✅ SSH Rule Confirmed:** Port 22 is open from anywhere (0.0.0.0/0)
   
   **Issue Analysis:** Security group rules are correctly configured. The connectivity issue may be:
   - EC2 instance stopped/terminated
   - Network ACLs blocking traffic
   - Instance-level firewall (ufw/iptables)
   - AWS region/availability zone issues

2. **✅ EC2 Instance Status (CONFIRMED RUNNING)**
   ```
   Instance: ec2-github-runner (i-08cfc5a1df5f3edf8)
   Instance State: Running ✅
   Status Checks: 2/2 checks passed ✅
   Instance Type: t2.nano
   Availability Zone: ap-southeast-1b
   Public IP: 18.136.198.116 (UPDATED)
   ```
   
   **✅ Instance Health Confirmed:** EC2 is running properly with all checks passed

3. **Network Connectivity Test**
   ```bash
   # Test SSH connectivity from local machine (CONFIRMED FAILING)
   ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.136.198.116 -v
   
   # Test basic connectivity
   ping 18.136.198.116
   
   # Check if port 22 is reachable
   telnet 18.136.198.116 22
   ```

4. **Alternative SCP Methods (WILL ALSO FAIL until connectivity fixed)**
   ```bash
   # Use standard SCP with verbose output
   scp -v -i "D:\pem\ec2-runner.pem" file.tar.gz ubuntu@18.136.198.116:~/
   
   # Use rsync as alternative
   rsync -avz -e "ssh -i D:\pem\ec2-runner.pem" file.tar.gz ubuntu@18.136.198.116:~/
   
   # Use SFTP for testing
   sftp -i "D:\pem\ec2-runner.pem" ubuntu@18.136.198.116
   ```

### **GitHub Actions Deployment Fixes**

**🚨 CURRENT ISSUE:** Repository secrets contain outdated IP address

**SOLUTION:** Update GitHub repository secrets immediately:

```yaml
# Current GitHub Actions workflow expects these secrets:
EC2_HOST: 18.136.198.116     # ← UPDATE THIS (was 18.141.159.49)
EC2_USER: ubuntu
EC2_SSH_KEY: [Private key content]
```

**After updating secrets, use retry mechanism in workflow:**

```yaml
- name: Deploy with retry mechanism
  run: |
    for i in {1..3}; do
      if scp -i key.pem -o ConnectTimeout=30 file.tar.gz ubuntu@18.136.198.116:~/; then
        break
      else
        echo "Attempt $i failed, retrying..."
        sleep 10
      fi
    done
```

### **Health Check Commands**
```bash
# System health
docker ps
systemctl status docker
sudo ./svc.sh status

# Network connectivity
curl http://localhost:3000
ssh -T git@github.com
ping 18.136.198.116
nslookup 18.136.198.116

# EC2 connectivity
ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.136.198.116 "uptime"

# Logs
docker-compose logs
journalctl -u actions.runner.*
```

---

## 📈 **Next Steps & Improvements**

### **Immediate Actions**
1. **✅ RESOLVED** → EC2 security group SSH access confirmed (port 22 open)
2. **⚠️ EC2 Instance Status** → Check if instance is running and not stopped
3. **🔍 Network Investigation** → Check Network ACLs and instance-level firewall
4. **📍 Region/AZ Check** → Verify instance location and routing
5. **🔄 Instance Restart** → Consider stopping/starting the instance if needed

### **Future Enhancements**
1. **Security** → SSL/TLS certificates for HTTPS
2. **Scalability** → Load balancing and auto-scaling
3. **Backup** → Automated backup and rollback strategies
4. **Monitoring** → Application performance monitoring (APM)
5. **Optimization** → Build caching and optimization

---

## 📞 **Support & Maintenance**

### **Key Files to Monitor**
- `~/actions-runner/` - Runner installation
- `~/.ssh/` - SSH key configuration  
- `/home/ubuntu/CI-CD-NEXTJS/` - Application deployment
- `.github/workflows/deploy.yml` - CI/CD configuration

### **Regular Maintenance Tasks**
- [ ] Update runner version quarterly
- [ ] Rotate SSH keys annually
- [ ] Update Docker images monthly
- [ ] Review security groups quarterly
- [ ] Monitor disk space weekly

---

**Document Version:** 1.0  
**Last Updated:** July 28, 2025  
**Maintained By:** Development Team