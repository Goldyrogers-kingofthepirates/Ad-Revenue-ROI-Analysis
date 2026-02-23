import instaloader
import pandas as pd
import time
from datetime import datetime

# 1. Initialize the engine
L = instaloader.Instaloader()

# 2. Your 5 target profiles
target_profiles = ["User_ID_1", "User_ID_2", "User_ID_3", "User_ID_4", "User_ID_5"]

all_data = []

for username in target_profiles:
    print(f"--- Accessing: {username} ---")
    try:
        profile = instaloader.Profile.from_username(L.context, username)
        
        video_count = 0
        # 3. Pulling content until we find 30 VIDEOS
        for post in profile.get_posts():
            if video_count >= 30: 
                break
            
            # --- THE FILTER ---
            # If it is NOT a video, we skip it
            if not post.is_video:
                continue
            
            video_count += 1
            print(f"[{username}] Found Video {video_count} of 30...")
            
            # 4. Gathering data for the video
            all_data.append({
                "Account": username,
                "Date": post.date_local.strftime('%Y-%m-%d'),
                "Time": post.date_local.strftime('%H:%M:%S'),
                "Likes": post.likes,
                "Views": post.video_view_count, # Views are guaranteed now
                "Comments_Count": post.comments,
                "Hashtags": ", ".join(post.caption_hashtags),
                "Caption": post.caption
            })
            
            # Pause between posts
            time.sleep(4) 

        # 120-second 'Cool Down' between accounts
        print(f"Finished {username}. Waiting 120 seconds...")
        time.sleep(120) 

    except Exception as e:
        print(f"Error on {username}: {e}")
        time.sleep(600)

# 5. Save to CSV
df = pd.DataFrame(all_data)
df.to_csv("video_analysis_data.csv", index=False)
print("\n--- PROJECT DATA READY: video_analysis_data.csv ---")