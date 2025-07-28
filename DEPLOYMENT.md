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
| **EC2 Instance** | `18.141.159.49` |
| **SSH Key Type** | ED25519 |

---

## ✅ **Deployment Progress Summary**

### **Phase 1: Infrastructure Setup**
- [x] **EC2 Instance Configuration**
  - Ubuntu EC2 instance launched on AWS
  - Security groups configured (ports 22, 80, 443, 3000)
  - Instance IP: `18.141.159.49`
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
| **EC2 Instance** | ✅ **Running** | `18.141.159.49` |
| **Docker** | ✅ **Configured** | Ubuntu user, sudo-less access |
| **SSH Authentication** | ✅ **Working** | Both EC2 and GitHub access |
| **Self-Hosted Runner** | ✅ **Active** | System service, auto-restart |
| **GitHub Actions** | ✅ **Ready** | Automated deployment configured |
| **Repository** | ✅ **Accessible** | Cloned and ready on EC2 |

---

## 🚀 **Quick Start Commands**

### **Connect to EC2**
```bash
# Using EC2 key pair
ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.141.159.49

# Using SSH key (after setup)
ssh -i "C:/Users/USER/.ssh/id_ed25519" ubuntu@18.141.159.49
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
EC2_HOST = 18.141.159.49
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
ssh -i "D:\pem\ec2-runner.pem" ubuntu@18.141.159.49

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

### **Health Check Commands**
```bash
# System health
docker ps
systemctl status docker
sudo ./svc.sh status

# Network connectivity
curl http://localhost:3000
ssh -T git@github.com

# Logs
docker-compose logs
journalctl -u actions.runner.*
```

---

## 📈 **Next Steps & Improvements**

### **Immediate Actions**
1. **Testing** → Validate complete CI/CD pipeline with code push
2. **Monitoring** → Set up deployment logs and health monitoring
3. **Environment** → Configure production environment variables

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