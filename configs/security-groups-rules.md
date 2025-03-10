# 🚀 Security Group Rules for AWS Scalable Web Application  

This document contains the security group configurations for **EC2**, **RDS**, and **Application Load Balancer (ALB)** in the `scalable-webapp-vpc`.

---

## **🔹 Security Group: EC2 Web Server (`scalable-webapp-sg`)**
This security group is assigned to the **EC2 instances hosting the web application**.

### ✅ Inbound Rules:
| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Source** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow HTTP Traffic | HTTP | TCP | 80 | 0.0.0.0/0 | Allows web traffic from the internet |
| Allow SSH Access (Optional) | SSH | TCP | 22 | My IP | Allows SSH access for management |

📌 *Port 22 (SSH) should be restricted to **My IP** only for security reasons.*  

### ✅ Outbound Rules:
| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Destination** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow Web Traffic | HTTP | TCP | 80 | 0.0.0.0/0 | Allows outbound web traffic |
| Allow Secure Web Traffic | HTTPS | TCP | 443 | 0.0.0.0/0 | Allows outbound secure web traffic |

---

## **🔹 Security Group: RDS Database (`scalable-webapp-rds-sg`)**
This security group is assigned to **Amazon RDS**, ensuring that only EC2 instances in the web application can access the database.

### ✅ Inbound Rules:
| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Source** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow MySQL/Aurora | MySQL/Aurora | TCP | 3306 | scalable-webapp-sg | Allows database access only from EC2 instances |

📌 *By setting the source to `scalable-webapp-sg`, only the web application servers can connect to the database, improving security.*  

### ✅ Outbound Rules:
| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Destination** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow All Outbound | All | All | All | 0.0.0.0/0 | Allows RDS to send responses |

---

## **🔹 Security Group: Application Load Balancer (ALB) (`scalable-webapp-alb-sg`)**
This security group is assigned to the **Application Load Balancer (ALB)**, allowing traffic from the internet to the EC2 instances.

### ✅ Inbound Rules:
| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Source** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow HTTP | HTTP | TCP | 80 | 0.0.0.0/0 | Allows inbound web traffic from the internet |

📌 *Since the ALB is public-facing, it allows inbound traffic from anywhere (`0.0.0.0/0`).*

### ✅ Outbound Rules:
| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Destination** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow Traffic to EC2 | HTTP | TCP | 80 | scalable-webapp-sg | Routes traffic from ALB to EC2 instances |

📌 *By restricting outbound traffic to `scalable-webapp-sg`, only web servers behind the ALB receive traffic.*

---

## **🔹 Additional Security Considerations**
- **Do not expose RDS (port 3306) to the public.** Only allow connections from the EC2 security group.  
- **Use an ALB instead of opening EC2 instances directly to the internet.**  
- **Avoid using `0.0.0.0/0` for SSH (port 22).** Always restrict it to `My IP`.  
- **If enabling HTTPS (443), attach an SSL certificate to the ALB and update security groups accordingly.**  

---
