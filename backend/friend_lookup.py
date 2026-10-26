
import json
import os
from pathlib import Path

# Find the JSON file relative to this Python script
DATA_FILE = Path(__file__).parent / "data" / "friends.json"


def load_friends():
    bucket = os.getenv("MIA_FRIENDS_BUCKET")

    if bucket:
        import boto3

        key = os.getenv("MIA_FRIENDS_KEY", "friends.json")
        response = boto3.client("s3").get_object(
            Bucket=bucket,
            Key=key
        )
        data = json.loads(response["Body"].read())
    else:
        with open(DATA_FILE, "r", encoding="utf-8") as file:
            data = json.load(file)

    return data["friends"]



def find_friend(name):
    """Find matching friends by name or nickname."""
    friends = load_friends()
    search_name = name.strip().lower()

    # Both friends can be called Mike
    if search_name == "mike":
        return [
            friend for friend in friends
            if friend["name"].lower() in ("mike wyse", "michael cerilli")
        ]

    matches = []

    for friend in friends:
        full_name = friend["name"].lower()
        nickname = (friend.get("nickname") or "").lower()
        last_name = full_name.split()[-1]
        aliases = [alias.lower() for alias in friend.get("aliases", [])]

        if search_name in (full_name, nickname, last_name) or search_name in aliases:
            matches.append(friend)

    return matches




if __name__ == "__main__":
    name = input("Who is calling Mia? ")

    matches = find_friend(name)

    if len(matches) > 1:
        print(
            "\nMia: Which Mike am I talking to? "
            "Guinness-beer-loving Mike Wyse, "
            "or cottage-loving Mike Cerilli?"
        )

    elif len(matches) == 1:
        friend = matches[0]

        print(f"\nFound: {friend['name']}")
        print(f"Personality: {', '.join(friend['personality'])}")
        print(f"Interests: {', '.join(friend['interests'])}")

        print("\nFunny facts:")
        for fact in friend["fun_facts"]:
            print(f"- {fact}")

    else:
        print(
            "\nMia: Hmm, I don't recognize that name. "
            "Oh, you must be a friend of Dom!"
        )

