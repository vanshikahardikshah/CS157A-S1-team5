# CS157A-S1-team5

## NearFix - A Service Request Application

This project is a Java/JSP web application for connecting customers with local service providers.

## Implemented functional requirements

The updated project now includes these additional customer-facing requirements:

1. **Viewing providers' profiles**
   - Customers can open a public provider profile page.
   - The page shows the provider's business name, contact email, contact number, service ZIP code, approval status, listed services, and upcoming availability.

2. **Booking provider appointments**
   - Customers can request a booking for a provider service.
   - Customers choose from the provider's available appointment slots.
   - A booking request is stored in the `bookings` table with `pending` status.
   - The selected availability slot is removed once booked to prevent duplicate booking of the same slot.

3. **Payment**
   - Customers enter credit-card payment information when submitting a booking request.
   - For proof of concept, payment is assumed successful when the required fields are entered.
   - Payment data is stored in the `payments` table using the original report attributes: `payment_id`, `card_last4`, `payment_method`, `payment_date`, `amount`, and `payment_status`.
   - Booking/payment association is stored through the `has_payment` relationship table, matching the original report's `HasPayment(Booking_ID, Payment_ID)` relationship.

### Also included
- **Customer booking history page** so customers can review submitted booking requests and current statuses.
- **Provider booking page enhancement** so providers can see the service name and customer name for each booking request.

## Prerequisites
- Java 11 or higher
- Maven 3.6+
- MySQL 8.0+

## Database setup

1. Open MySQL Command Line Client or MySQL Workbench.
2. Run the contents of `setup-database.sql`.

Or from the command line:

```bash
mysql -u root -p < setup-database.sql
```

The setup script will:
- Create the `nearfix` database
- Create the application user `nearfix_user` with no password
- Create the tables used by the application

## Database configuration

The application is configured by default to connect to:
- **Host:** localhost
- **Port:** 3306
- **Database:** nearfix
- **Username:** nearfix_user
- **Password:** (empty)

These defaults are defined in:
- `src/main/java/com/nearfix/dao/DatabaseConnection.java`

You can also override them with environment variables:
- `DB_URL`
- `DB_USER`
- `DB_PASSWORD`

## Running the application

```bash
mvn clean package
mvn tomcat7:run
```

The application will start on:

```text
http://localhost:8080/nearfix
```

## Main routes

- `/` - home page and service search
- `/providers/view?providerId=...` - public provider profile
- `/customer/book?serviceId=...` - booking request page
- `/customer/bookings` - customer booking history
- `/provider/profile` - provider dashboard
- `/provider/services` - provider services management
- `/provider/availability` - provider availability management
- `/provider/bookings` - provider booking management
