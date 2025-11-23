-- sample_data.sql
-- Inserts sample data for local testing of the Lankalive-like MVP

-- IMPORTANT: this script is intended to run against the 'lankalive' database.
-- If the database does not yet exist, create it first (run as a superuser):
--   CREATE DATABASE lankalive;
-- Then run this file with psql and ensure you are connected to 'lankalive':
--   \connect lankalive
-- When running non-interactively you can also run:
--   psql -d lankalive -f sql_script/sample_data.sql


-- Categories
INSERT INTO categories (id, name, slug, order_index, is_active) VALUES
  (uuid_generate_v4(), 'Political News', 'political-news', 1, true),
  (uuid_generate_v4(), 'Foreign News', 'foreign-news', 2, true),
  (uuid_generate_v4(), 'Gossip Live', 'gossip-live', 3, true),
  (uuid_generate_v4(), 'Sports Live', 'sports-live', 4, true),
  (uuid_generate_v4(), 'Business Live', 'business-live', 5, true),
  (uuid_generate_v4(), 'Entertainment', 'entertainment', 6, true);

-- Tags
INSERT INTO tags (id, name, slug) VALUES
  (uuid_generate_v4(), 'breaking', 'breaking'),
  (uuid_generate_v4(), 'exclusive', 'exclusive'),
  (uuid_generate_v4(), 'opinion', 'opinion');

-- Media (use placeholder paths — ensure these files exist in ./static/uploads/... for front-end rendering)
INSERT INTO media_assets (id, type, file_name, url, width, height, mime_type, alt_text, caption, credit)
VALUES
  (uuid_generate_v4(), 'image', 'hero1.jpg', 'https://i.imgur.com/9kid1ou.png', 1200, 800, 'image/jpeg', 'Hero image 1', 'Caption for hero 1', 'Photographer A'),
  (uuid_generate_v4(), 'image', 'thumb1.jpg', 'https://i.imgur.com/abgzvBQ.png', 400, 300, 'image/jpeg', 'Thumb 1', 'Thumb caption', 'Photographer B');

-- Admin user (password hash placeholder — replace with actual bcrypt hash before use)
INSERT INTO users (id, name, email, password_hash, role)
VALUES (uuid_generate_v4(), 'Admin', 'admin@example.com', '$2a$12$CJXZcp2lj1XnMnm.iKTfV.1cgbu/7w7BMKloVWxUcDU9ILKT4Bgva', 'admin'); 

-- Example articles
INSERT INTO articles (id, status, title, summary, body_richtext, slug, primary_category_id, hero_image_url, is_breaking, is_highlight, is_featured, published_at)
VALUES
  (uuid_generate_v4(), 'published', 'President Calls for Unity and Justice in Deepavali Message', 'In his Deepavali message, the President emphasized the importance of national unity and social justice, calling on all Sri Lankans to work together in the spirit of the festival of lights to build a more inclusive and prosperous nation.', '<p>President Anura Kumara Dissanayake has issued a special message for Deepavali, emphasizing the core values of unity and justice that the festival represents. His message highlights the importance of coming together as a nation to overcome challenges and build a better future for all Sri Lankans. The President noted that Deepavali, the festival of lights, symbolizes the victory of light over darkness and good over evil. He called on all citizens to embrace these values and work toward creating a more harmonious and equitable society. This message comes at a significant time as the country continues its journey toward economic recovery and social reconciliation. The President''s emphasis on unity and justice reflects his administration''s commitment to inclusive governance and equal opportunities for all communities. <em>Image courtesy: Newswire.lk</em></p>', 'president-calls-for-unity-and-justice-in-deepavali-message', (SELECT id FROM categories WHERE slug='political-news' LIMIT 1), 'https://i.imgur.com/9kid1ou.png', true, true, false, now()),
  (uuid_generate_v4(), 'published', 'Sri Lanka Crowned No. 1 Travel Destination for October 2025 by Time Out Magazine', 'Time Out magazine has recognized Sri Lanka as the world''s premier travel destination for October 2025, highlighting the island''s unique blend of cultural heritage, natural beauty, and warm hospitality that continues to captivate international visitors.', '<p>Sri Lanka has achieved a remarkable milestone in global tourism, being ranked as the No. 1 travel destination for October 2025 by the prestigious Time Out magazine. This recognition underscores the island nation''s growing appeal among international travelers seeking authentic experiences and diverse attractions. The ranking highlights Sri Lanka''s extraordinary combination of ancient cultural sites, pristine beaches, lush tea plantations, and rich wildlife. Time Out''s selection comes at a time when the country has witnessed significant growth in its tourism sector, with visitors drawn to its UNESCO World Heritage Sites, including the ancient cities of Anuradhapura and Polonnaruwa, the sacred city of Kandy, and the historic Galle Fort. The island''s diverse landscapes offer something for every type of traveler. From the misty mountains of the central highlands to the golden beaches of the southern coast, Sri Lanka provides a wealth of experiences within a compact geographical area. The country''s renowned hospitality and increasingly improved tourism infrastructure have also contributed to this prestigious recognition. This accolade is expected to boost Sri Lanka''s tourism industry significantly, attracting more international visitors during the peak travel season. Tourism officials and industry stakeholders have welcomed the recognition, viewing it as validation of their efforts to position Sri Lanka as a must-visit destination on the global tourism map. <em>The Time Out ranking considers factors such as cultural offerings, natural attractions, culinary experiences, and value for money, all areas where Sri Lanka has demonstrated exceptional appeal to modern travelers seeking meaningful and memorable journeys.</em></p>', 'sri-lanka-crowned-no-1-travel-destination-for-october-2025-by-time-out-magazine', (SELECT id FROM categories WHERE slug='sports-live' LIMIT 1), 'https://i.imgur.com/abgzvBQ.png', false, false, false, now() - interval '1 day');
  
-- Associate tags with articles
INSERT INTO article_tag (article_id, tag_id)
SELECT a.id, t.id FROM articles a, tags t WHERE a.slug='sample-breaking-story' AND t.slug='breaking';

-- Homepage sections
INSERT INTO homepage_sections (id, key, title, layout_type, config_json)
VALUES
  (uuid_generate_v4(), 'highlights', 'Highlights', 'hero-list', '{"limit": 6}'),
  (uuid_generate_v4(), 'hot_news', 'Hot News', 'list', '{"limit": 10}');

-- Pin articles into highlights
INSERT INTO homepage_section_items (id, section_id, article_id, order_index)
SELECT uuid_generate_v4(), hs.id, a.id, 1
FROM homepage_sections hs, articles a
WHERE hs.key='highlights' AND a.slug='sample-breaking-story';
