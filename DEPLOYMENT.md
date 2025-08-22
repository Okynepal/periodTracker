# PeriodTracker Nepal AWS Deployment Documentation

## Overview

This document outlines the deployment architecture, reasoning, and security considerations for the PeriodTracker application deployed on AWS infrastructure.

## Deployment Architecture

### Infrastructure Components

#### 1. **AWS App Runner Services**
- **CMS Service**: `https://2pnqpvuhwc.ap-south-1.awsapprunner.com/`
- **API Service**: https://niinwqw3up.ap-south-1.awsapprunner.com/
- **Region**: `ap-south-1` (Asia Pacific - Mumbai)

#### 2. **Amazon RDS PostgreSQL Database**
- **Cluster**: `periodtracker-cluster.cluster-cduga8c80pbs.ap-south-1.rds.amazonaws.com`
- **Database Name**: `periodtracker`
- **Port**: `5432`
- **Schema**: `periodtracker`

#### 3. **Amazon ECR (Elastic Container Registry)**
- **Repository**: `periodtracker/cms`
- **Repository**: `periodtracker/api`
- **Image Storage**: Docker images for containerized deployments

### Deployment Strategy

#### **Containerized Microservices Architecture**
┌─────────────────┐    ┌─────────────────┐
│   Mobile App    │    │   Web Client    │
│   (React Native)│    │                 │
└─────────┬───────┘    └─────────┬───────┘
          │                      │
          └──────────┬───────────┘
                     │
          ┌─────────────────────┐
          │   AWS App Runner   │
          │                     │
          │  ┌───────────────┐  │
          │  │  CMS Service  │  │
          │  │  (Port 5000)  │  │
          │  └───────────────┘  │
          │                     │
          │  ┌───────────────┐  │
          │  │  API Service  │  │
          │  │  (Port 3000)  │  │
          │  └───────────────┘  │
          └─────────┬───────────┘
                    │
          ┌─────────────────────┐
          │   Amazon RDS        │
          │   PostgreSQL        │
          │   (Port 5432)       │
          └─────────────────────┘

## Deployment Reasoning

### **Why AWS App Runner?**

1. **Simplified Container Deployment**
   - Automatic scaling based on traffic
   - Built-in load balancing
   - No infrastructure management required

2. **Cost Efficiency**
   - Pay-per-use pricing model
   - Automatic scaling down during low traffic
   - No idle resource costs

3. **Developer Experience**
   - Direct integration with ECR
   - Automatic deployments on image updates (available but not setup, doing it manually right now)
   - Built-in monitoring and logging

### **Why Amazon RDS PostgreSQL?**

1. **Managed Database Service**
   - Automated backups and maintenance
   - High availability with Multi-AZ deployment
   - Automatic security patching

2. **Performance and Reliability**
   - Optimized for production workloads
   - Built-in monitoring and alerting
   - Point-in-time recovery capabilities

3. **Security**
   - Encryption at rest and in transit
   - VPC isolation
   - IAM integration

### **Why ap-south-1 Region?**

1. **Geographic Proximity**
   - Reduced latency for users in Nepal, closest AWS data center
   - Better user experience

2. **Data Residency**
   - Compliance with local data protection regulations
   - Reduced data transfer costs

## Security Architecture

### **Network Security**

#### 1. **VPC Isolation**
- RDS database deployed in private subnets
- No direct internet access to database
- App Runner services act as secure gateway


### **Application Security**

#### 1. **Authentication & Authorization**
- Secret management through environment variables

#### 2. **Environment Variable Security**
```yaml
# Runtime Environment Variables (App Runner)
DATABASE_HOST: periodtracker-cluster.cluster-cduga8c80pbs.ap-south-1.rds.amazonaws.com
DATABASE_NAME: periodtracker
DATABASE_USERNAME: periodtracker
DATABASE_PASSWORD: [SECURED]
DATABASE_SCHEMA: periodtracker
PASSPORT_SECRET: [SECURED]
NODE_ENV: production
```

#### 3. **Database Security**
- Schema-based data isolation
- Parameterized queries to prevent SQL injection
- Connection pooling and timeout management

### **Container Security**

#### 1. **Image Security**
- Base images from trusted sources
- Regular security scanning
- Minimal attack surface

#### 2. **Runtime Security**
- Non-root user execution
- Resource limits and constraints
- Environment-specific configurations


## Deployment Process

### **CI/CD Pipeline**

1. **Build Phase**
   ```bash
   # Build Docker image
   docker build -t periodtracker-cms .
   ```

2. **Tag and Push to ECR**
   ```bash
   # Tag for ECR
   docker tag periodtracker-cms:latest 533267005222.dkr.ecr.ap-south-1.amazonaws.com/periodtracker/cms:latest
   
   # Push to ECR
   docker push 533267005222.dkr.ecr.ap-south-1.amazonaws.com/periodtracker/cms:latest
   ```

3. **Deploy to App Runner**
   - Automatic deployment triggered by new ECR image
   - Rolling deployment with zero downtime
   - Health checks and rollback capabilities

## Monitoring and Observability

### **Application Monitoring**
- AWS CloudWatch integration
- Application logs and metrics
- Performance monitoring
- Error tracking and alerting

### **Database Monitoring**
- RDS Performance Insights
- Query performance analysis
- Connection monitoring
- Automated backup verification

## Scalability Considerations

### **Horizontal Scaling**
- App Runner automatic scaling based on CPU/memory
- Database read replicas for read-heavy workloads
- CDN integration for static assets

### **Performance Optimization**
- Connection pooling
- Query optimization
- Caching strategies
- Image optimization

## Disaster Recovery

### **Backup Strategy**
- Automated RDS backups (7-day retention)
- Point-in-time recovery capabilities
- Cross-region backup replication

### **Recovery Procedures**
- Database restoration procedures
- Application deployment rollback
- Infrastructure as Code for rapid recovery

## Cost Optimization

### **Resource Optimization**
- App Runner pay-per-use model
- RDS instance right-sizing
- ECR lifecycle policies
- CloudWatch log retention policies

### **Monitoring and Alerts**
- Cost monitoring dashboards
- Budget alerts and thresholds
- Resource utilization tracking

## Compliance and Governance

### **Data Protection**
- Encryption at rest and in transit
- Access logging and auditing
- Data retention policies
- Privacy controls

### **Access Management**
- IAM roles and policies
- Principle of least privilege
- Regular access reviews
- Multi-factor authentication

---

**Document Version**: 1.0  
**Last Updated**: January 2025  
**Maintained By**: Development Team  
**Next Review**: March 2025          