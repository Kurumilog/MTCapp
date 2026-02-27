Deployment Walkthrough: NestJS Backend to Production
The backend is now live and fully operational on the DigitalOcean server. This document summarizes the deployment state and provides verification links.

🚀 Live Environment
Status: UP and Running
API Base URL: https://kurumi.software/api
Interactive Documentation: Swagger UI
🛠 Infrastructure Summary
1. Nginx Reverse Proxy
Configured at /etc/nginx/sites-available/kurumi.

Proxies /api/ to http://localhost:8080/api/
Proxies /swagger to http://localhost:8080/swagger
Forces HTTPS via Let's Encrypt certificates.
2. Docker Containers
Orchestrated via docker compose.

mts_backend: The NestJS application.
mts_postgres: PostgreSQL 15 database with persistent volume.
3. Database
Schema: Automatically synchronized (synchronize: true for initial setup).
External Access: Accessible via DBeaver on port 5432 (or via SSH tunnel).
✅ Verification Steps Performed
Nginx Connectivity: Verified that https://kurumi.software responds with the frontend placeholder.
Swagger Access: Verified that https://kurumi.software/swagger/ loads correctly.
API Logic: Tested the /api/auth/register endpoint. Confirmed that it successfully creates users in the production database.
Logs Integrity: Confirmed that environment variables (DB_HOST, JWT_SECRET, etc.) are correctly loaded from 
.env.prod
.
📱 For Mobile App Development
Use the Swagger UI to test endpoint schemas. The accessToken should be sent in the Authorization header as a Bearer token. Refer to 
architecture.md
 for detailed logic on token rotation.