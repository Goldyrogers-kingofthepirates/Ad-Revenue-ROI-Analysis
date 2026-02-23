import pandas as pd
import sqlite3

def move_to_sql():
    try:
        # Load the VIDEO-ONLY CSV
        df = pd.read_csv("video_analysis_data.csv")
        conn = sqlite3.connect('insta_project.db')
        
        # We use 'replace' to ensure the old photo data is gone
        df.to_sql('video_trends', conn, if_exists='replace', index=False)
        
        conn.close()
        print("--- SUCCESS: SQL Database now contains ONLY Video data ---")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    move_to_sql()