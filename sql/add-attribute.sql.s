-- Replace these values with your desired attribute details
INSERT INTO "Nepal Partner" ("name", "emoji", "isActive", "lang") 
VALUES ('Your Attribute Name', '🏥', true, 'en')
RETURNING id, name, emoji, "isActive", lang;