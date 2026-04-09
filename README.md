# CS157A-S1-team5

## NearFix - A Service Request Application

### Prerequisites
- Java 11 or higher
- Maven 3.6+
- MySQL 8.0+

### Database Setup

1. **Run the setup script** to create the database and user account:
   - Open MySQL Command Line Client or MySQL Workbench
   - Connect as root (or any admin user)
   - Run the contents of `setup-database.sql`
   
   Alternatively, from the command line:
   ```bash
   mysql -u root -p < setup-database.sql
   ```

2. **The script will:**
   - Create the `nearfix` database
   - Create the `users` table with proper schema
   - Create a `User` account with no password
   - Grant all privileges on the nearfix database to the User account

### Database Configuration

The application is configured to connect to:
- **Host:** localhost
- **Port:** 3306
- **Database:** nearfix
- **Username:** User
- **Password:** (empty)

These settings are defined in: `src/main/java/com/nearfix/dao/DatabaseConnection.java`

### Running the Application

```bash
mvn clean compile
mvn tomcat7:run
```

The application will start on http://localhost:8080/nearfix
