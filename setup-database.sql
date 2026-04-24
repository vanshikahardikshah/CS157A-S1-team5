CREATE DATABASE IF NOT EXISTS nearfix;                    
  USE nearfix;                                   

  -- Create an app database user with no password
  CREATE USER IF NOT EXISTS 'nearfix_user'@'localhost';
  GRANT ALL PRIVILEGES ON nearfix.* TO 'nearfix_user'@'localhost';

  CREATE TABLE IF NOT EXISTS users (
      user_id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(255) NOT NULL UNIQUE,                               
      password_hash VARCHAR(255) NOT NULL,
      salt VARCHAR(64) NOT NULL,                                        
      zip_code VARCHAR(10),                                             
      role ENUM('customer', 'provider', 'admin') NOT NULL DEFAULT
  'customer',                                                           
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP        
  );                                                                    
  
  CREATE TABLE IF NOT EXISTS providers (                                
      provider_id INT AUTO_INCREMENT PRIMARY KEY,           
      user_id INT NOT NULL UNIQUE,               
      business_name VARCHAR(150),
      contact_number VARCHAR(20),                                       
      approval_status ENUM('pending', 'approved', 'rejected') NOT NULL
  DEFAULT 'pending',                                                    
      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
  );                                                                    
  
  CREATE TABLE IF NOT EXISTS service_categories (                       
      category_id INT AUTO_INCREMENT PRIMARY KEY,           
      category_name VARCHAR(100) NOT NULL UNIQUE,
      description TEXT
  );                                                                    
  
  CREATE TABLE IF NOT EXISTS services (                                 
      service_id INT AUTO_INCREMENT PRIMARY KEY,            
      provider_id INT NOT NULL,                  
      category_id INT NOT NULL,
      service_name VARCHAR(150) NOT NULL,
      description TEXT,                                                 
      price DECIMAL(10,2) NOT NULL,
      location_zip VARCHAR(10),                                         
      FOREIGN KEY (provider_id) REFERENCES providers(provider_id) ON
  DELETE CASCADE,                                                       
      FOREIGN KEY (category_id) REFERENCES
  service_categories(category_id)                                       
  );                                                        
                                                 
  CREATE TABLE IF NOT EXISTS availability (                             
      availability_id INT AUTO_INCREMENT PRIMARY KEY,
      provider_id INT NOT NULL,                                         
      available_date DATE NOT NULL,                         
      start_time TIME NOT NULL,                  
      end_time TIME NOT NULL,
      FOREIGN KEY (provider_id) REFERENCES providers(provider_id) ON    
  DELETE CASCADE
  );                                                                    
                                                            
  CREATE TABLE IF NOT EXISTS bookings (          
      booking_id INT AUTO_INCREMENT PRIMARY KEY,
      customer_id INT NOT NULL,
      service_id INT NOT NULL,
      booking_date DATE NOT NULL,                                       
      status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT
  NULL DEFAULT 'pending',                                               
      total_price DECIMAL(10,2) NOT NULL,                   
      FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE     
  CASCADE,
      FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE
   CASCADE                                                  
  );                