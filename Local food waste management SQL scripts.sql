USE food_waste_db;

-- 1. Providers and receivers count by city
SELECT p.City, 
       COUNT(DISTINCT p.Provider_ID) AS Total_Providers, 
       COUNT(DISTINCT r.Receiver_ID) AS Total_Receivers
FROM providers p
LEFT JOIN receivers r ON p.City = r.City
GROUP BY p.City
ORDER BY Total_Providers DESC
LIMIT 10;

-- 2. Provider type contributing the most food
SELECT Provider_Type, 
       SUM(Quantity) AS Total_Food_Units, 
       COUNT(Food_ID) AS Total_Donations
FROM food_listings
GROUP BY Provider_Type
ORDER BY Total_Food_Units DESC;

-- 3. Contact info of food providers in a specific city
SELECT Name, Type, Address, City, Contact
FROM providers
ORDER BY City, Name
LIMIT 10;

-- 4. Receivers that claimed the most food
SELECT r.Name AS Receiver_Name, 
       r.Type, 
       COUNT(c.Claim_ID) AS Total_Claims, 
       SUM(f.Quantity) AS Total_Quantity_Claimed
FROM claims c
JOIN receivers r ON c.Receiver_ID = r.Receiver_ID
JOIN food_listings f ON c.Food_ID = f.Food_ID
GROUP BY r.Name, r.Type
ORDER BY Total_Quantity_Claimed DESC
LIMIT 10;

-- 5. Total quantity of food available from all providers
SELECT SUM(Quantity) AS Total_Available_Food_Units, 
       COUNT(Food_ID) AS Total_Listings
FROM food_listings;

-- 6. City with highest number of food listings
SELECT Location AS City, 
       COUNT(Food_ID) AS Total_Listings, 
       SUM(Quantity) AS Total_Food_Quantity
FROM food_listings
GROUP BY Location
ORDER BY Total_Listings DESC
LIMIT 10;

-- 7. Most commonly available food types
SELECT Food_Type, 
       COUNT(Food_ID) AS Listing_Count, 
       SUM(Quantity) AS Total_Quantity
FROM food_listings
GROUP BY Food_Type
ORDER BY Total_Quantity DESC;

-- 8. Claims made for each food item
SELECT f.Food_Name, 
       COUNT(c.Claim_ID) AS Total_Claims
FROM food_listings f
LEFT JOIN claims c ON f.Food_ID = c.Food_ID
GROUP BY f.Food_Name
ORDER BY Total_Claims DESC;

-- 9. Provider with highest successful claims
SELECT p.Name AS Provider_Name, 
       p.Type, 
       COUNT(c.Claim_ID) AS Successful_Claims
FROM claims c
JOIN food_listings f ON c.Food_ID = f.Food_ID
JOIN providers p ON f.Provider_ID = p.Provider_ID
WHERE c.Status = 'Completed'
GROUP BY p.Name, p.Type
ORDER BY Successful_Claims DESC
LIMIT 10;

-- 10. Percentage of Completed vs Pending vs Cancelled claims
SELECT Status, 
       COUNT(Claim_ID) AS Total_Claims,
       ROUND(COUNT(Claim_ID) * 100.0 / (SELECT COUNT(*) FROM claims), 2) AS Percentage
FROM claims
GROUP BY Status;

-- 11. Average quantity of food claimed per receiver
SELECT r.Name AS Receiver_Name, 
       ROUND(AVG(f.Quantity), 2) AS Avg_Claim_Quantity
FROM claims c
JOIN receivers r ON c.Receiver_ID = r.Receiver_ID
JOIN food_listings f ON c.Food_ID = f.Food_ID
WHERE c.Status = 'Completed'
GROUP BY r.Name
ORDER BY Avg_Claim_Quantity DESC
LIMIT 10;

-- 12. Most claimed meal type
SELECT f.Meal_Type, 
       COUNT(c.Claim_ID) AS Total_Claims
FROM claims c
JOIN food_listings f ON c.Food_ID = f.Food_ID
GROUP BY f.Meal_Type
ORDER BY Total_Claims DESC;

-- 13. Total quantity donated by each provider
SELECT p.Name AS Provider_Name, 
       p.City, 
       SUM(f.Quantity) AS Total_Quantity_Donated
FROM food_listings f
JOIN providers p ON f.Provider_ID = p.Provider_ID
GROUP BY p.Name, p.City
ORDER BY Total_Quantity_Donated DESC
LIMIT 10;

-- 14. Near-expiry food tracking
SELECT Food_Name, 
       Expiry_Date, 
       Location, 
       Quantity
FROM food_listings
ORDER BY Expiry_Date ASC
LIMIT 10;

-- 15. City distribution efficiency (Listings vs Claims)
SELECT p.City, 
       COUNT(DISTINCT f.Food_ID) AS Total_Food_Listings, 
       COUNT(DISTINCT c.Claim_ID) AS Total_Claims_Processed
FROM food_listings f
JOIN providers p ON f.Provider_ID = p.Provider_ID
LEFT JOIN claims c ON f.Food_ID = c.Food_ID
GROUP BY p.City
ORDER BY Total_Claims_Processed DESC
LIMIT 10;