# CS157A-S1-team5

## NearFix - A Service Request Application

### Prerequisites
- Java 11 or higher
- Maven 3.6+
- MySQL 8.0+

### Database Setup

1. Create the database, tables, app user, and starter categories:

```bash
mysql -u root -p < setup-database.sql
```

This script will:
- Create the `nearfix` database
- Create the application tables
- Create the `nearfix_user` MySQL account with an empty password
- Seed starter service categories so providers can add services immediately

### Database Configuration

The application defaults to:
- **Host:** localhost
- **Port:** 3306
- **Database:** nearfix
- **Username:** nearfix_user
- **Password:** (empty)

You can override them with environment variables:
- `DB_URL`
- `DB_USER`
- `DB_PASSWORD`

These settings are defined in `src/main/java/com/nearfix/dao/DatabaseConnection.java`.

### Running the Application

```bash
mvn clean package
mvn tomcat7:run
```

The application will start on:
- http://localhost:8080/nearfix

This version includes:
- fixed search error handling
- ZIP-only search support
- provider business-name search
- consistent database setup docs
- seeded default service categories
